SELECT
  -- Sales info
  s.invoice,
  s.addeddate,
  s.time_,
  s.sales_type,
  s.sheet,
  s.sales_sheet,
  s.sales_pack,

  -- Product info
  p.product_id,
  p.brand_name,
  p.clean_brand_name,
  p.dosage_form,
  p.pack_size,
  p.pack_unit,
  p.product_type,
  p.price_inr,

  -- Ingredient info
  ing.id AS ingredient_id,
  ing.ingredient_name,
  ing.therapeutic_class,

  -- Manufacturer info
  m.id AS manufacturer_id,
  m.name AS manufacturer_name,

  -- Pharmacy info
  ph.group_key,
  ph.pharmacy_id,
  ph.zone_id,
  ph.city_id,

  -- Insurance info
  ins.id AS insurance_id,
  ins.insurance_name,
  ins.average_coverage

FROM sales s
LEFT JOIN products p ON s.product_id = p.product_id
LEFT JOIN ingredients ing ON p.ingredient_id = ing.id
LEFT JOIN manufacturer m ON p.manufacturer_id = m.id
LEFT JOIN pharmacy ph ON s.group_key = ph.group_key
LEFT JOIN insurance ins ON s.insurance_id = ins.id;


