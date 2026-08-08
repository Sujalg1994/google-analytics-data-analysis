-- GA4 channel performance analysis
-- BigQuery Standard SQL
--
-- Replace `your-project.analytics_123456789.events_*` with the GA4 export table.
-- Change the conversion event list to match the business definition.

WITH event_base AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS event_date,
    event_name,
    user_pseudo_id,
    CONCAT(
      user_pseudo_id,
      '-',
      CAST(
        (SELECT value.int_value
         FROM UNNEST(event_params)
         WHERE key = 'ga_session_id') AS STRING
      )
    ) AS session_key,
    COALESCE(
      collected_traffic_source.manual_source,
      traffic_source.source,
      '(direct)'
    ) AS source,
    COALESCE(
      collected_traffic_source.manual_medium,
      traffic_source.medium,
      '(none)'
    ) AS medium,
    COALESCE(
      (SELECT value.int_value
       FROM UNNEST(event_params)
       WHERE key = 'session_engaged'),
      SAFE_CAST(
        (SELECT value.string_value
         FROM UNNEST(event_params)
         WHERE key = 'session_engaged') AS INT64
      ),
      0
    ) AS session_engaged,
    COALESCE(ecommerce.purchase_revenue, 0) AS purchase_revenue
  FROM `your-project.analytics_123456789.events_*`
  WHERE _TABLE_SUFFIX BETWEEN
    FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY))
    AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
),

session_level AS (
  SELECT
    event_date,
    session_key,
    ANY_VALUE(source) AS source,
    ANY_VALUE(medium) AS medium,
    MAX(session_engaged) AS is_engaged,
    MAX(IF(event_name IN ('purchase', 'generate_lead', 'sign_up'), 1, 0))
      AS has_conversion,
    COUNTIF(event_name = 'purchase') AS purchases,
    SUM(purchase_revenue) AS revenue
  FROM event_base
  WHERE session_key IS NOT NULL
  GROUP BY event_date, session_key
)

SELECT
  event_date,
  source,
  medium,
  COUNT(DISTINCT session_key) AS sessions,
  SUM(is_engaged) AS engaged_sessions,
  SAFE_DIVIDE(SUM(is_engaged), COUNT(DISTINCT session_key))
    AS engagement_rate,
  SUM(has_conversion) AS converting_sessions,
  SAFE_DIVIDE(SUM(has_conversion), COUNT(DISTINCT session_key))
    AS session_conversion_rate,
  SUM(purchases) AS purchases,
  SUM(revenue) AS revenue,
  SAFE_DIVIDE(SUM(revenue), SUM(purchases)) AS average_order_value
FROM session_level
GROUP BY event_date, source, medium
ORDER BY event_date DESC, revenue DESC;


-- Daily user and event trend
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS event_date,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNT(*) AS events,
  COUNTIF(event_name = 'page_view') AS page_views,
  COUNTIF(event_name IN ('purchase', 'generate_lead', 'sign_up'))
    AS conversion_events
FROM `your-project.analytics_123456789.events_*`
WHERE _TABLE_SUFFIX BETWEEN
  FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY))
  AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
GROUP BY event_date
ORDER BY event_date;
