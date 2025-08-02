CREATE TABLE dim_time (
  time_id TIME PRIMARY KEY,
  hour INT,
  minute INT,
  second INT,
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
  sale_id BIGINT PRIMARY KEY AUTO_INCREMENT,
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

