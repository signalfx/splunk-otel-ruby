# Troubleshooting

## Enable debug logging

When things are not working, a good first step is to restart the program with
debug logging enabled. Do this by setting the `OTEL_LOG_LEVEL` environment
variable to `debug`.

```sh
export OTEL_LOG_LEVEL="debug"
```

Make sure to unset the environment variable after the issue is resolved, as its
output might overload systems if left on indefinitely.
