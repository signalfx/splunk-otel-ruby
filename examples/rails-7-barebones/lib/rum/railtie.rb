module Rum
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      headers = headers.merge({ "Access-Control-Expose-Headers" => "Server-Timing" })

      [status, headers, body]
    end
  end

  class Railtie < Rails::Railtie
    config.before_initialize do |app|
      app.middleware.insert_before(
        0,
        Middleware
      )
    end
  end
end
