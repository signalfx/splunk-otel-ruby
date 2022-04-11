# Advanced Configuration

## Exporting directly to Splunk Observability Cloud

The OTLP trace exporter can export directly to Splunk Observability Cloud. To
achieve that, you need to set the `SPLUNK_ACCESS_TOKEN` and optional the
`SPLUNK_REALM` (defaults to `us0` if access token is set).

| Environment variable                   | Default value | Support     | Description                                                                                                                                          |
| -------------------------------------- | ------------  | ----------- | ---                                                                                                                                                  |
| `SPLUNK_ACCESS_TOKEN`                  | unset         | Stable      | (Optional) Auth token allowing exporters to communicate directly with the Splunk cloud, passed as `X-SF-TOKEN` header.                               |
| `SPLUNK_REALM`                         | unset         | Stable      | (Optional) A realm is a self-contained deployment that hosts organizations. You can find your realm name on your profile page in the user interface. |
