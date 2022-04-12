# Advanced configuration

## Exporting directly to Splunk Observability Cloud

To export traces directly to Splunk Observability Cloud, bypassing the Collector,
set the `SPLUNK_ACCESS_TOKEN` and `SPLUNK_REALM` environment variables.

| Environment variable                   | Default value | Support     | Description                                                                                                                                          |
| -------------------------------------- | ------------  | ----------- | ---                                                                                                                                                  |
| `SPLUNK_ACCESS_TOKEN`                  | unset         | Stable      | Splunk authentication token that lets exporters send data directly to Splunk Observability Cloud. Unset by default. Not required unless you need to send data to the Observability Cloud ingest endpoint. See [Create and manage authentication tokens using Splunk Observability Cloud](https://docs.splunk.com/Observability/admin/authentication-tokens/tokens.html#admin-tokens).                               |
| `SPLUNK_REALM`                         | unset         | Stable      | (Optional) A realm is a self-contained deployment that hosts organizations. You can find your realm name on your profile page in the user interface. |
