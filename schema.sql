CREATE TABLE ingredients (
  id INT PRIMARY KEY,
  ingredient_name VARCHAR(255),
  therapeutic_class VARCHAR(255)
);

CREATE TABLE manufacturer (
  id INT PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE pharmacy (
  id INT PRIMARY KEY, 
  pharmacy_id VARCHAR(50),
  zone_id VARCHAR(50),
  city_id VARCHAR(50)
);

CREATE TABLE products (
  product_id VARCHAR(255) PRIMARY KEY,
  clean_name VARCHAR(255),
  manufacturer_id INT,
  dosage_form VARCHAR(255),
  pack_size FLOAT,
  pack_unit VARCHAR(50),
  ingredient_id INT,
  FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

CREATE TABLE sales (
  invoice INT,
  product_id VARCHAR(255),
  pharmacy_id INT,
  sheet FLOAT,
  sales_sheet FLOAT,
  sales_pack FLOAT,
  sale_date DATETIME,
  sale_time TIME,
  sale_type VARCHAR(50),
  acquisition_type VARCHAR(50),
  PRIMARY KEY (invoice, product_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (pharmacy_id) REFERENCES pharmacy(id)
);

