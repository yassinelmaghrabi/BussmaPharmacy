-- Enable advanced options and bulk insert
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

-- Load manufacturer
BULK INSERT manufacturer
FROM '/tmp/setup/data/manufacturer.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

-- Load ingredients
BULK INSERT ingredients
FROM '/tmp/setup/data/ingredients.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

-- Load products
BULK INSERT products
FROM '/tmp/setup/data/products.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

-- Load pharmacy
BULK INSERT pharmacy
FROM '/tmp/setup/data/pharmacy.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);

BULK INSERT sales
FROM '/tmp/setup/data/sales.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
BULK INSERT insurance
FROM '/tmp/setup/data/insurance.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
SELECT 'manufacturer' AS table_name, COUNT(*) AS row_count FROM manufacturer;
SELECT 'ingredients' AS table_name, COUNT(*) AS row_count FROM ingredients;
SELECT 'products' AS table_name, COUNT(*) AS row_count FROM products;
SELECT 'pharmacy' AS table_name, COUNT(*) AS row_count FROM pharmacy;
SELECT 'sales' AS table_name, COUNT(*) AS row_count FROM sales;
