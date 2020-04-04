# EKS

Files to run EKS scaling tests.

A couple things have to be changed:

- setup in `main.tf` depending on the region
- instance types and allowed IAM role in `eks.tf`
- `replicas` in `app.tf` from `1` to `3500`

To get the metrics from CloudWatch:

```
aws cloudwatch get-metric-data \
  --region us-east-1 \
  --metric-data-queries file://cw-metric-query.json \
  --start-time 2020-03-15T16:22:00.1300Z \
  --end-time 2020-03-15T18:16:00.608Z \
  > eks.json
```
