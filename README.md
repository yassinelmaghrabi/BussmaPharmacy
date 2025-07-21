# 💊 Pharmacy Sales Database for Bussma

A normalized relational database schema with source CSV files and Containerized database designed for analyzing pharmaceutical product sales, tracking product composition, and mapping manufacturer and pharmacy metadata — ideal for business intelligence, data analytics, and supply chain optimization in the healthcare domain.

---

## 🗂️ Schema Overview

This project models the core components of a pharmacy sales ecosystem using a relational database with strong referential integrity and normalized structure. It includes:

- **Product catalog and composition**
- **Manufacturer registry**
- **Pharmacy network**
- **Detailed sales transactions**

---

## 🧱 Tables and Relationships

### `products`

Represents all products sold, including packaging and manufacturer data.

| Column           | Type         | Description                          |
|------------------|--------------|--------------------------------------|
| `product_id`     | `VARCHAR(255)` | Unique ID of the product             |
| `clean_name`     | `VARCHAR(255)` | Human-readable product name          |
| `manufacturer_id`| `INT`          | Foreign key to `manufacturer`        |
| `dosage_form`    | `VARCHAR(255)` | Form of medication (e.g. tablet)     |
| `pack_size`      | `FLOAT`        | Quantity per pack                    |
| `pack_unit`      | `VARCHAR(50)`  | Unit of measurement (e.g. mg, ml)    |

🔗 **Foreign key:** `manufacturer_id → manufacturer(id)`

---

### `ingredients`

Captures the primary active ingredient and therapeutic class for each product.

| Column             | Type           | Description                          |
|--------------------|----------------|--------------------------------------|
| `product_id`       | `VARCHAR(255)` | FK to `products`                     |
| `ingredient_name`  | `VARCHAR(255)` | Active ingredient                    |
| `therapeutic_class`| `VARCHAR(255)` | Drug classification (e.g. Analgesic) |

🔗 **Foreign key:** `product_id → products(product_id)`

---

### `manufacturer`

List of known manufacturers.

| Column   | Type           | Description              |
|----------|----------------|--------------------------|
| `id`     | `INT`          | Unique manufacturer ID   |
| `name`   | `VARCHAR(255)` | Manufacturer name        |

---

### `pharmacy`

Encodes location-based metadata for each pharmacy.

| Column       | Type           | Description             |
|--------------|----------------|-------------------------|
| `id`         | `INT`          | Internal pharmacy ID    |
| `pharmacy_id`| `VARCHAR(50)`  | Composite source ID     |
| `zone_id`    | `VARCHAR(50)`  | Zone location           |
| `city_id`    | `VARCHAR(50)`  | City identifier         |

---

### `sales`

Captures all pharmacy sales transactions.

| Column            | Type           | Description                         |
|-------------------|----------------|-------------------------------------|
| `invoice`         | `INT`          | Invoice number                      |
| `product_id`      | `VARCHAR(255)` | FK to `products`                    |
| `pharmacy_id`     | `INT`          | FK to `pharmacy`                    |
| `sheet`           | `FLOAT`        | Quantity sold in sheets             |
| `sales_sheet`     | `FLOAT`        | Number of sheets in sale            |
| `sales_pack`      | `FLOAT`        | Number of packs in sale             |
| `sale_date`       | `DATETIME`     | Date of sale                        |
| `sale_time`       | `TIME`         | Time of transaction                 |
| `sale_type`       | `VARCHAR(50)`  | Type (e.g. retail, wholesale)       |
| `acquisition_type`| `VARCHAR(50)`  | How stock was acquired              |

🔗 **Foreign keys:**

- `product_id → products(product_id)`
- `pharmacy_id → pharmacy(id)`

---

## 📊 Use Cases

- **Product-level analytics** — track trends in ingredients, therapeutic categories, or dosage forms.
- **Sales forecasting** — analyze historical sale volume and frequency.
- **Geographic analysis** — visualize product movement across zones/cities.
- **Manufacturer reports** — identify top-selling manufacturers and associated revenue.

---

## ⚙️ Technologies

- 🐘 **SQL Server / PostgreSQL / MySQL** (portable schema)
- 🐍 Compatible with **Python (Pandas, SQLAlchemy)**
- 📊 BI-ready for **Power BI, Tableau, Metabase**

---

## 🚀 Quickstart

1. Create the tables using the SQL schema provided.
2. Bulk load the data using `BULK INSERT` or a Python ETL script.
3. Start querying!

---

## 🤝 Contributing

Got improvements, extensions (e.g., pharmacy stock levels, secondary ingredients), or want to integrate external APIs? Contributions are welcome!

---

## 📝 License

MIT License — free to use, modify, and distribute.
