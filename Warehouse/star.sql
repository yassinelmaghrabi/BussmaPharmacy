IF DB_ID('warehouse') IS NULL
    CREATE DATABASE warehouse;
GO

USE warehouse;
GO


CREATE TABLE dim_time (
  time_id TIME PRIMARY KEY,
  hour INT,
  minute INT,
  period VARCHAR(10)
);
CREATE TABLE dim_date (
  date_id DATE PRIMARY KEY,
  day INT,
  month INT,
  year INT,
  quarter INT,
  weekday_name VARCHAR(10)
);
CREATE TABLE dim_insurance (
  insurance_id INT PRIMARY KEY,
  insurance_name VARCHAR(255),
  average_coverage FLOAT
);
CREATE TABLE dim_pharmacy (
  pharmacy_key VARCHAR(50) PRIMARY KEY,
  pharmacy_name VARCHAR(50),
  zone VARCHAR(50),
  city VARCHAR(50)
);
CREATE TABLE dim_product (
  product_id VARCHAR(255) PRIMARY KEY,
  brand_name VARCHAR(255),
  clean_brand_name VARCHAR(255),
  manufacturer_name VARCHAR(255),
  dosage_form VARCHAR(255),
  pack_size FLOAT,
  pack_unit VARCHAR(50),
  ingredient_name VARCHAR(255),
  therapeutic_class VARCHAR(255),
  product_type VARCHAR(50),
  price FLOAT
);
CREATE TABLE fact_sales (
  sale_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  invoice INT,
  product_id VARCHAR(255),
  pharmacy_key VARCHAR(50),
  insurance_id INT,
  date_id DATE,
  time_id TIME,
  sheet FLOAT,
  sales_sheet FLOAT,
  sales_pack FLOAT,
  sales_type VARCHAR(50),
  FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
  FOREIGN KEY (pharmacy_key) REFERENCES dim_pharmacy(pharmacy_key),
  FOREIGN KEY (insurance_id) REFERENCES dim_insurance(insurance_id),
  FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
  FOREIGN KEY (time_id) REFERENCES dim_time(time_id)
);

-- 1. dim_date
INSERT INTO dim_date (date_id, day, month, year, quarter, weekday_name)
SELECT DISTINCT
    CAST(addeddate AS DATE) AS date_id,
    DATEPART(DAY, addeddate),
    DATEPART(MONTH, addeddate),
    DATEPART(YEAR, addeddate),
    DATEPART(QUARTER, addeddate),
    DATENAME(WEEKDAY, addeddate)
FROM master.dbo.sales
WHERE addeddate IS NOT NULL;

-- 2. dim_time
INSERT INTO dim_time (time_id, hour, minute,period)
SELECT DISTINCT
    time_ AS time_id,
    DATEPART(HOUR, time_),
    DATEPART(MINUTE, time_),
    CASE WHEN DATEPART(HOUR, time_) < 12 THEN 'AM' ELSE 'PM' END AS period
FROM master.dbo.sales
WHERE time_ IS NOT NULL;

-- 3. dim_insurance
INSERT INTO dim_insurance (insurance_id, insurance_name, average_coverage)
SELECT
    id, insurance_name, average_coverage
FROM master.dbo.insurance;

-- 4. dim_pharmacy
INSERT INTO dim_pharmacy (pharmacy_key, pharmacy_name, zone, city)
SELECT DISTINCT
    group_key,
    group_key AS pharmacy_name,
    zone_id,
    city_id
FROM master.dbo.pharmacy;

-- 5. dim_product
INSERT INTO dim_product (
    product_id, brand_name, clean_brand_name, manufacturer_name,
    dosage_form, pack_size, pack_unit,
    ingredient_name, therapeutic_class,
    product_type, price
)
SELECT
    p.product_id,
    p.brand_name,
    p.clean_brand_name,
    m.name AS manufacturer_name,
    p.dosage_form,
    p.pack_size,
    p.pack_unit,
    i.ingredient_name,
    i.therapeutic_class,
    p.product_type,
    p.price_inr
FROM master.dbo.products p
JOIN master.dbo.manufacturer m ON p.manufacturer_id = m.id
JOIN master.dbo.ingredients i ON p.ingredient_id = i.id;

-- 6. fact_sales
INSERT INTO fact_sales (
    invoice, product_id, pharmacy_key, insurance_id,
    date_id, time_id,
    sheet, sales_sheet, sales_pack, sales_type
)
SELECT
    s.invoice,
    s.product_id,
    s.group_key,
    s.insurance_id,
    CAST(s.addeddate AS DATE) AS date_id,
    s.time_ AS time_id,
    s.sheet,
    s.sales_sheet,
    s.sales_pack,
    s.sales_type
FROM master.dbo.sales s;

