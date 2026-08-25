-- Query A: what was known 24 hours after the event was first recorded
WITH event_start AS (
  SELECT
    PARSE_TIMESTAMP('%Y%m%d%H%M%S', CAST(MIN(EventTimeDate) AS STRING)) AS t0
  FROM `gdelt-bq.gdeltv2.eventmentions`
  WHERE GlobalEventID = 1293149040
)

SELECT
  COUNT(*) AS mentions_known_at_T
FROM `gdelt-bq.gdeltv2.eventmentions`, event_start
WHERE GlobalEventID = 1293149040
  AND PARSE_TIMESTAMP('%Y%m%d%H%M%S', CAST(MentionTimeDate AS STRING))
      <= TIMESTAMP_ADD(event_start.t0, INTERVAL 24 HOUR);


-- Query B: what is known today, no time boundary
SELECT COUNT(*) AS mentions_known_today
FROM `gdelt-bq.gdeltv2.eventmentions`
WHERE GlobalEventID = 1293149040;