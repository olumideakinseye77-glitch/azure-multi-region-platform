# Origin health alert validation

Test date: 17 October 2026.

- Stopped the UK South application to simulate an outage.
- Azure Monitor recorded the origin health alert as Fired at 16:47:27 UTC.
- Restarted UK South and confirmed its /health endpoint returned HTTP 200.
- Observed UK South origin health metrics recovering.
- Subsequently confirmed the alert condition changed to Resolved.
- The query returned no resolution timestamp, so the exact resolution time was not captured.

This verifies alert firing and automatic resolution.
Email notifications were not configured or tested.
