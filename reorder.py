from itertools import product
import pandas as pd
import hashlib
import random


# Function to generate 12-digit numeric barcode from product name
def generate_barcode(name):
    hash_part = int(hashlib.sha256(name.encode()).hexdigest(), 16) % (10**8)
    rand_part = random.randint(1000, 9999)
    return f"{hash_part:08d}{rand_part:04d}"  # 12-digit string


# Desired column orders
csv_column_orders = {
    "manufacturer.csv": ["id", "name"],
    "ingredients.csv": ["product_id", "ingredient_name", "therapeutic_class"],
    "products.csv": [
        "product_id",
        "clean_name",
        "manufacturer_id",
        "dosage_form",
        "pack_size",
        "pack_unit",
    ],
    "pharmacy.csv": ["id", "pharmacy_id", "zone_id", "city_id"],
    "sales.csv": [
        "invoice",
        "product_id",
        "pharmacy_id",
        "sheet",
        "sales_sheet",
        "sales_pack",
        "sale_date",
        "sale_time",
        "sale_type",
        "acquisition_type",
    ],
}

# Fix and save each CSV
for file, columns in csv_column_orders.items():
    try:
        df = pd.read_csv(file)
        df.drop_duplicates(inplace=True)
        if file == "products.csv":
            df.drop_duplicates(subset=["product_id"], inplace=True)
        # Reorder columns
        df = df[columns]

        # Save
        df.to_csv(file, index=False)
        print(f"✅ Fixed: {file}")

    except Exception as e:
        print(f"❌ Error fixing {file}: {e}")

print("✅ Duplicates removed.")
