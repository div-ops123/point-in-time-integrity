SELECT
  COUNTIF(DATEADDED <= 20260302000000) AS events_known_by_mar2,
  COUNTIF(DATEADDED <= 20260305000000) AS events_known_by_mar5,
  COUNTIF(DATEADDED <= 20260310000000) AS events_known_by_mar10,
  COUNT(*) AS events_known_today
FROM `gdelt-bq.gdeltv2.events`
WHERE ActionGeo_FullName LIKE '%Hormuz%'
  AND SQLDATE BETWEEN 20260220 AND 20260401;