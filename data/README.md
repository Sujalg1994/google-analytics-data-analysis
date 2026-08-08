# Data guidance

Do not commit raw GA4 exports or user-level identifiers to this public repository.

The Python script expects an aggregated CSV named `channel_performance.csv` with these columns:

| Column | Type | Example |
|---|---|---|
| event_date | date | 2026-08-01 |
| source | text | google |
| medium | text | organic |
| sessions | integer | 1250 |
| engaged_sessions | integer | 820 |
| engagement_rate | decimal | 0.656 |
| converting_sessions | integer | 43 |
| session_conversion_rate | decimal | 0.0344 |
| purchases | integer | 28 |
| revenue | decimal | 2450.75 |
| average_order_value | decimal | 87.53 |

Generate the file from `sql/ga4_kpi_analysis.sql`, then place it in this folder locally. The repository's `.gitignore` excludes CSV exports by default.
