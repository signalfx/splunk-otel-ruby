# Advanced configuration

## Exporting directly to Splunk Observability Cloud

To export traces directly to Splunk Observability Cloud, bypassing the Collector,
set the `SPLUNK_ACCESS_TOKEN` and `SPLUNK_REALM` environment variables.

| Environment variable                   | Default value | Support     | Description                                                                                                                                          |
| -------------------------------------- | ------------  | ----------- | ---                                                                                                                                                  |
| `SPLUNK_ACCESS_TOKEN`                  | unset         | Stable      | Splunk authentication token that lets exporters send data directly to Splunk Observability Cloud. Unset by default. Not required unless you need to send data to the Observability Cloud ingest endpoint. See [Create and manage authentication tokens using Splunk Observability Cloud](https://docs.splunk.com/Observability/admin/authentication-tokens/tokens.html#admin-tokens).                               |
| `SPLUNK_REALM`                         | us0         | Stable      | The name of your organization’s realm, for example, us0. When you set the realm, traces are sent directly to the ingest endpoint of Splunk Observability Cloud, bypassing the Splunk OpenTelemetry Collector. |
