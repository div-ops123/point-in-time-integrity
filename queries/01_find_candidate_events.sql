SELECT
  GlobalEventID,
  SQLDATE,
  ActionGeo_FullName,
  EventRootCode,
  QuadClass,
  GoldsteinScale,
  NumMentions,
  NumArticles,
  SOURCEURL
FROM `gdelt-bq.gdeltv2.events`
WHERE SQLDATE BETWEEN 20260228 AND 20260310
  AND (
    ActionGeo_FullName LIKE '%Hormuz%'
    OR ActionGeo_FullName LIKE '%Strait of Hormuz%'
  )
ORDER BY NumMentions DESC
LIMIT 20;