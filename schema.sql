-- 1. Ingredients Table
CREATE TABLE ingredients (
  id INT PRIMARY KEY,
  ingredient_name VARCHAR(255),
  therapeutic_class VARCHAR(255)
);

-- 2. Manufacturer Table
CREATE TABLE manufacturer (
  id INT PRIMARY KEY,
  name VARCHAR(255)
);

-- 3. Pharmacy Table
CREATE TABLE pharmacy (
  group_id VARCHAR(50) PRIMARY KEY, 
  pharmacy_id VARCHAR(50),
  zone_id VARCHAR(50),
  city_id VARCHAR(50)
);

-- 4. Insurance Table
CREATE TABLE insurance (
  id INT PRIMARY KEY,
  insurance_name VARCHAR(255),
  average_coverage FLOAT
);

-- 5. Products Table
CREATE TABLE products (
  product_id VARCHAR(255) PRIMARY KEY,
  brand_name VARCHAR(255),
  manufacturer_id INT,
  dosage_form VARCHAR(255),
  pack_size INT,
  pack_unit INT,
  ingredient_id INT,
  product_type VARCHAR(50),
  FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

-- 6. Sales Table
CREATE TABLE sales (
  invoice INT,
  product_id VARCHAR(255),
  pharmacy_id INT,
  insurance_id INT,
  sheet FLOAT,
  sales_sheet FLOAT,
  sales_pack FLOAT,
  sale_date DATETIME,
  sale_time TIME,
  sale_type VARCHAR(50),
  PRIMARY KEY (invoice, product_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (pharmacy_id) REFERENCES pharmacy(group_id),
  FOREIGN KEY (insurance_id) REFERENCES insurance(id)
);

