# Sinatra and PG Example

This example contains a Sinatra webapp that connects to and queries a Postgres
database (see the `docker-compose.yml` file for running the database).

Sinatra and PG are instrumented through OpenTelemetry libraries enabled in
`config.ru`:

``` ruby
OpenTelemetry::SDK.configure do |c|
  c.use 'OpenTelemetry::Instrumentation::Sinatra'
  c.use 'OpenTelemetry::Instrumentation::PG'
end
```

## Usage

By default the spans are output to the console but this can be overriden by
setting the environment varirable `OTEL_TRACES_EXPORTER`.

``` shell
$ docker-compose up -d

$ bundle install

$ bundle exec rackup
```

From a separate shell:

``` shell
$ curl 0.0.0.0:9292
query result is [["1", "2", "3"]]
```
