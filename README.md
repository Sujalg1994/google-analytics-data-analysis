# Google Analytics 4 Data Analysis

A portfolio project demonstrating how a data analyst can turn Google Analytics 4 (GA4) event data into acquisition, engagement, conversion, and revenue insights using BigQuery SQL, Python, and a BI dashboard.

## Business questions

- Which acquisition channels bring high-quality users?
- How are users engaging with the website over time?
- Which channels and landing pages produce conversions?
- Where are users dropping out of the conversion journey?
- How much revenue does each channel generate?

## Core KPIs

| KPI | Definition |
|---|---|
| Users | Distinct GA4 `user_pseudo_id` values |
| Sessions | Distinct user and `ga_session_id` combinations |
| Engaged sessions | Sessions flagged by GA4 as engaged |
| Engagement rate | Engaged sessions divided by sessions |
| Conversions | Selected business conversion events |
| Session conversion rate | Sessions with a conversion divided by sessions |
| Revenue | Sum of purchase revenue |
| Average order value | Revenue divided by purchases |

See [docs/kpi_dictionary.md](docs/kpi_dictionary.md) for detailed definitions and caveats.

## Repository structure

```text
.
├── dashboard/                # Dashboard specification
├── data/                     # Data guidance; no private raw GA4 data
├── docs/                     # KPI definitions
├── python/                   # Reusable analysis script
├── sql/                      # BigQuery analysis queries
├── requirements.txt
└── README.md
```

## Workflow

1. Enable the GA4-to-BigQuery export.
2. Replace the example project and dataset in the SQL file.
3. Update the conversion-event list to match the business.
4. Run the BigQuery queries and export aggregated results.
5. Analyse the export with Python or connect it to Power BI/Tableau.
6. Build and validate the dashboard using the supplied specification.

## Quick start

```bash
python -m venv .venv
pip install -r requirements.txt
python python/channel_analysis.py --input data/channel_performance.csv --output outputs
```

The Python script expects the aggregated channel output described in [data/README.md](data/README.md).

## Tools

- Google Analytics 4
- Google BigQuery and SQL
- Python, pandas, matplotlib and seaborn
- Power BI or Tableau

## Data privacy

Do not commit raw GA4 exports, user identifiers, service-account keys, or credentials. This repository is designed for aggregated, portfolio-safe outputs.

## Project status

Starter framework created. Replace example values with a real or approved GA4 dataset and add dashboard screenshots when the analysis is complete.
