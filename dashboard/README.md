# Dashboard specification

Build the dashboard in Power BI, Tableau, or Looker Studio using aggregated GA4 outputs.

## Page 1 — Executive overview

- KPI cards: users, sessions, engagement rate, conversions, conversion rate, revenue
- Line chart: users and sessions by date
- Bar chart: revenue by channel
- Funnel: session start → product view → add to cart → purchase
- Filters: date, source, medium, device category and country

## Page 2 — Acquisition

- Channel table: users, sessions, engaged sessions, conversions, conversion rate and revenue
- Source/medium comparison
- New-versus-returning-user split
- Campaign performance with cost metrics when advertising data is available

## Page 3 — Content and conversion

- Landing-page performance
- Top content by views and engagement
- Conversion trend
- Funnel drop-off by stage
- Device and country breakdown

## Dashboard QA

- Reconcile headline totals against validated SQL output.
- Use consistent date, currency and percentage formats.
- Show filter context and the last refresh date.
- Avoid pie charts with many categories.
- Flag small samples and missing attribution.
- Add a short insight and recommended action beside each major visual.
