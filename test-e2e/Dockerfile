FROM ruby:3-buster
RUN apt-get update -qq && apt-get install -y netcat

# ruby comes with older versions of bundler sometimes
RUN gem install bundler -v "2.3.14"

ADD ./ /splunk-otel-ruby
WORKDIR /splunk-otel-ruby

RUN gem update --system
RUN bundle install

CMD ["bundle", "exec", "rake", "test_e2e"]
