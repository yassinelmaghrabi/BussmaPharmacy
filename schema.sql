CREATE TABLE products (
  product_id VARCHAR(255) PRIMARY KEY,
  clean_name VARCHAR(255),
  manufacturer_id INT,
  dosage_form VARCHAR(255),
  pack_size FLOAT,
  pack_unit VARCHAR(50)
);

CREATE TABLE ingredients (
  product_id VARCHAR(255) PRIMARY KEY,
  ingredient_name VARCHAR(255),
  therapeutic_class VARCHAR(255)
);

CREATE TABLE manufacturer (
  id INT PRIMARY KEY,
  name VARCHAR(255)
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
  PRIMARY KEY (invoice, product_id)
);


CREATE TABLE pharmacy (
  id INT PRIMARY KEY, 
  pharmacy_id VARCHAR(50),
  zone_id VARCHAR(50),
  city_id VARCHAR(50)
);


ALTER TABLE products
ADD FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id);

ALTER TABLE ingredients
ADD FOREIGN KEY (product_id) REFERENCES products(id);

ALTER TABLE sales
ADD FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (pharmacy_id) REFERENCES pharmacy(id);

