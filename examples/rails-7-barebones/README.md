# Rails 7 example

## Starting

```shell
docker-compose up -d
```

Which starts:
- Open Telemetry Collector preconfigured for end-to-end testing
- Rails 7 application instance
- Test runner

You can check the output of E2E tests by running either:
- `docker-compose logs tester`
- `ruby tests-e2e/rails_7_barebones_test.rb` (reruns the tests from your machine)

To create spans send requests to an endpoint:

```
curl http://localhost:3000/
```

The spans will be printed in the console (stdout), and they will also be sent to the Collector instance started by docker-compose.
