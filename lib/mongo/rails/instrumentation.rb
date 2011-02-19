module Mongo
  module Rails
    module Instrumentation
      autoload :Version, 'mongo/rails/instrumentation/version'
      autoload :Railtie, 'mongo/rails/instrumentation/railtie'
      autoload :LogSubscriber, 'mongo/rails/instrumentation/log_subscriber'
      autoload :ControllerRuntime, 'mongo/rails/instrumentation/controller_runtime'
    end
  end
end