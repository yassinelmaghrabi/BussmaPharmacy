import pandas as pd
import numpy as np
import random
import os
import hashlib


df = pd.read_parquet("./iran_enriched_with_india_full.parquet")
df.drop("barcode", axis=1, inplace=True)


def lowercase_string_columns(df):
    df_lower = df.copy()
    str_cols = df_lower.select_dtypes(include="object").columns
    for col in str_cols:
        df_lower[col] = df_lower[col].astype(str).str.lower()
    return df_lower


df = lowercase_string_columns(df)


original_count = len(df)
brand_counts = df["brand_name"].value_counts()
valid_brands = brand_counts[brand_counts >= 100].index
df = df[df["brand_name"].isin(valid_brands)]


dosage_mode_map = df.groupby("brand_name")["dosage_form"].agg(
    lambda x: x.mode().iloc[0] if not x.mode().empty else "unknown"
)

df["dosage_form"] = df.apply(
    lambda row: dosage_mode_map[row["brand_name"]]
    if row["brand_name"] in dosage_mode_map
    else row["dosage_form"],
    axis=1,
)

df["dosage_form"] = df["dosage_form"].replace("milk", "tablet")
print(
    df[df["brand_name"] == "diamin 75mg tablet"][
        ["brand_name", "dosage_form", "pack_unit"]
    ].value_counts()
)
filtered_count = len(df)
print(f"Rows before filtering: {original_count}")
print(f"Rows after filtering:  {filtered_count}")
print(f"Rows removed:          {original_count - filtered_count}")


samples = []
for _, group_df in df.groupby(["pharmacy_id", "city_id", "zone_id"]):
    frac = np.random.uniform(0.1, 0.2)

    n = max(1, int(len(group_df) * frac))
    sample = group_df.sample(n=n, random_state=42)
    samples.append(sample)
df = pd.concat(samples, ignore_index=True)
sampled_count = len(df)
print(f"Rows after sampling:   {sampled_count}")
print(f"Rows removed (total):  {original_count - sampled_count}")


int_cols = df.select_dtypes(include=["int", "float"]).columns
for col in int_cols:
    Q1 = df[col].quantile(0.10)
    Q3 = df[col].quantile(0.95)
    IQR = Q3 - Q1
    lower = Q1 - 1.5 * IQR
    upper = Q3 + 1.5 * IQR

    n_low = (df[col] < lower).sum()
    n_high = (df[col] > upper).sum()
    df[col] = df[col].clip(lower=lower, upper=upper)

    print(f"{col}: clipped {n_low} values below and {n_high} values above")


insurance_df = pd.read_csv("./Insurance.csv")
insurance_df.columns = ["policy_number", "code", "name", "end_date", "coverage"]
insurance_df.drop(columns=["policy_number", "end_date", "code"], inplace=True)

insurance_grouped = (
    insurance_df.groupby("name")["coverage"]
    .mean()
    .reset_index()
    .rename(columns={"name": "insurance_name", "coverage": "average_coverage"})
)
insurance_grouped.loc[len(insurance_grouped.index)] = ["No Insurance", 0]
insurance_grouped["id"] = range(1, len(insurance_grouped) + 1)
insurance_grouped = insurance_grouped[["id", "insurance_name", "average_coverage"]]

insurance_name_to_id = dict(
    zip(insurance_grouped["insurance_name"], insurance_grouped["id"])
)


unique_invoices = df["Invoice"].drop_duplicates().reset_index(drop=True)
random.seed(42)


def assign_insurance():
    if random.random() < 0.3:
        return "No Insurance"
    return random.choice(
        insurance_grouped[insurance_grouped.insurance_name != "No Insurance"][
            "insurance_name"
        ].tolist()
    )


invoice_insurance_map = {inv: assign_insurance() for inv in unique_invoices}
df["insurance_name"] = df["Invoice"].map(invoice_insurance_map)
df["insurance_id"] = df["insurance_name"].map(insurance_name_to_id)


manufacturer_df = df[["manufacturer"]].drop_duplicates().reset_index(drop=True)
manufacturer_df["manufacturer"] = (
    manufacturer_df["manufacturer"].fillna("Unknown").replace("", "Unknown")
)
manufacturer_df["id"] = manufacturer_df.index + 1
manufacturer_df.rename(columns={"manufacturer": "name"}, inplace=True)
manufacturer_df = manufacturer_df[["id", "name"]]

df = df.merge(manufacturer_df, left_on="manufacturer", right_on="name", how="left")
df.rename(columns={"id": "manufacturer_id"}, inplace=True)


known_map = (
    df[df["primary_ingredient"] != "Unknown"]
    .groupby("brand_name")[["primary_ingredient", "therapeutic_class"]]
    .agg(lambda x: x.mode().iloc[0] if not x.mode().empty else "Unknown")
)


def fill_ingredients(row):
    if row["primary_ingredient"] == "Unknown" and row["brand_name"] in known_map.index:
        return known_map.loc[row["brand_name"]]
    return pd.Series([row["primary_ingredient"], row["therapeutic_class"]])


df[["primary_ingredient", "therapeutic_class"]] = df.apply(fill_ingredients, axis=1)


ingredients_df = (
    df[["primary_ingredient", "therapeutic_class"]]
    .drop_duplicates()
    .rename(columns={"primary_ingredient": "ingredient_name"})
    .reset_index(drop=True)
)
ingredients_df["id"] = ingredients_df.index + 1
ingredients_df = ingredients_df[["id", "ingredient_name", "therapeutic_class"]]

df = df.merge(
    ingredients_df,
    left_on=["primary_ingredient", "therapeutic_class"],
    right_on=["ingredient_name", "therapeutic_class"],
    how="left",
)
df.rename(columns={"id": "ingredient_id"}, inplace=True)


def hash_product(row):
    concat = f"{row['brand_name']}_{row['dosage_form']}_{row['pack_size']}_{row['manufacturer_id']}_{row['ingredient_id']}"
    return hashlib.md5(concat.encode()).hexdigest()


df["product_id"] = df.apply(hash_product, axis=1)


df["product_type"] = df["type"] if "type" in df.columns else "prescription"
products_df = df[
    [
        "product_id",
        "brand_name",
        "manufacturer_id",
        "dosage_form",
        "pack_size",
        "pack_unit",
        "ingredient_id",
        "product_type",
        "price_inr",
    ]
].drop_duplicates()
products_df["price_inr"] = products_df["price_inr"].fillna(0)


pharmacy_df = df[["pharmacy_id", "zone_id", "city_id"]].drop_duplicates().copy()
pharmacy_df["group_key"] = (
    pharmacy_df["pharmacy_id"].astype(str)
    + "_"
    + pharmacy_df["zone_id"].astype(str)
    + "_"
    + pharmacy_df["city_id"].astype(str)
)
pharmacy_df = pharmacy_df[["group_key", "pharmacy_id", "zone_id", "city_id"]]

df["group_key"] = (
    df["pharmacy_id"].astype(str)
    + "_"
    + df["zone_id"].astype(str)
    + "_"
    + df["city_id"].astype(str)
)


sales_df = df[
    [
        "Invoice",
        "product_id",
        "group_key",
        "insurance_id",
        "Sheet",
        "Sales_Sheet",
        "Sales_pack",
        "addeddate",
        "time_",
        "type",
    ]
].copy()

sales_df.rename(
    columns={
        "Invoice": "invoice",
        "group_key": "pharmacy_id",
        "Sheet": "sheet",
        "Sales_Sheet": "sales_sheet",
        "Sales_pack": "sales_pack",
        "addeddate": "addeddate",
        "time_": "time_",
        "type": "sales_type",
    },
    inplace=True,
)

sales_df["addeddate"] = pd.to_datetime(sales_df["addeddate"], errors="coerce")
sales_df = sales_df[
    [
        "invoice",
        "product_id",
        "pharmacy_id",
        "insurance_id",
        "sheet",
        "sales_sheet",
        "sales_pack",
        "addeddate",
        "time_",
        "sales_type",
    ]
]


os.makedirs("tables", exist_ok=True)
products_df.to_csv("tables/products.csv", index=False)
ingredients_df.to_csv("tables/ingredients.csv", index=False)
manufacturer_df.to_csv("tables/manufacturer.csv", index=False)
pharmacy_df.to_csv("tables/pharmacy.csv", index=False)
sales_df.to_csv("tables/sales.csv", index=False)
insurance_grouped.to_csv("tables/insurance.csv", index=False)

print("\n All normalized tables exported.")
print("Table sizes:")
print(f"- Products: {len(products_df)}")
print(f"- Ingredients: {len(ingredients_df)}")
print(f"- Manufacturers: {len(manufacturer_df)}")
print(f"- Pharmacies: {len(pharmacy_df)}")
print(f"- Sales: {len(sales_df)}")
print(f"- Insurance: {len(insurance_grouped)}")
