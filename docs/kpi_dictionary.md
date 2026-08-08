# KPI dictionary

Use one agreed definition per KPI before publishing a dashboard. GA4 interface totals can differ from BigQuery because of identity, attribution, modelling, thresholding, time-zone, and late-arriving-event rules.

| KPI | Calculation | Recommended grain | Main caveat |
|---|---|---|---|
| Users | Distinct `user_pseudo_id` | Date, channel | Device-based, not necessarily a person |
| Sessions | Distinct user + `ga_session_id` | Date, channel | Exclude events without a session ID |
| Engaged sessions | Sessions where `session_engaged = 1` | Date, channel | Validate against the GA4 property configuration |
| Engagement rate | Engaged sessions / sessions | Date, channel | Use `SAFE_DIVIDE` to avoid divide-by-zero errors |
| Converting sessions | Sessions containing an approved conversion event | Date, channel | Maintain a documented event allow-list |
| Session conversion rate | Converting sessions / sessions | Date, channel | Do not divide conversion-event count by sessions |
| Purchases | Count of the `purchase` event | Date, channel | Validate duplicate transaction IDs |
| Revenue | Sum of `ecommerce.purchase_revenue` | Date, channel | Confirm currency handling and refunds |
| Average order value | Revenue / purchases | Date, channel | Exclude invalid or duplicate purchases |

## Reporting controls

- State the GA4 property time zone and reporting currency.
- Document the analysis date range and any excluded traffic.
- Exclude internal and test traffic consistently.
- Reconcile headline results with the GA4 interface before publishing.
- Label calculated metrics clearly when they differ from GA4 interface metrics.
- Never expose user-level identifiers in a public portfolio.
