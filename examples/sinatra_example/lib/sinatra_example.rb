# frozen_string_literal: true

require_relative "sinatra_example/version"
require "sinatra"
require "splunk/otel"

module SinatraExample
  class Error < StandardError; end

  # Sinatra example app with postgres query
  class App < Sinatra::Base
    set :bind, "0.0.0.0"

    get "/" do
      conn = PG::Connection.open(host: "localhost",
                                 port: "5432",
                                 user: "test",
                                 dbname: "test",
                                 password: "password")
      r = conn.exec("SELECT 1, 2, 3").values

      "query result is #{r}"
    end
  end
end
