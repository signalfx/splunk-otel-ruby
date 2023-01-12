# Instrumenting Rails

Install the instrumentation library by adding it to your project's `Gemfile`:

``` ruby
gem "opentelemetry-instrumentation-rails", "~> 0.24"
```

or install the gem using `bundle`:

```shell
bundle add opentelemetry-instrumentation-rails --version "~> 0.24"
```

Configure OpenTelemetry to use all available instrumentation libraries using the
`Splunk::Otel` module from `splunk/otel` and `use_all()` method:

``` ruby
require "splunk/otel"
...
Splunk::Otel.configure do |c|
  c.use_all()
end
```

You can disable individual components' instrumentation as options to
`use_all`. For example to disable Active Record instrumentation:

``` ruby
Splunk::Otel.configure do |c|
  c.use_all({ 'OpenTelemetry::Instrumentation::ActiveRecord' => { enabled: false } })
end
```

To enable only Rails an indiviual `c.use` can be used:

```ruby
Splunk::Otel.configure do |c|
  c.use 'OpenTelemetry::Instrumentation::Rails'
end
```

## Example

See the [readme for Rails 7 barebones example](../examples/rails-7-barebones/README.md).
