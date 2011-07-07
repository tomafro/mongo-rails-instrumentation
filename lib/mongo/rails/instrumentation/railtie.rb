require 'mongo/rails/instrumentation'

module Mongo::Rails::Instrumentation
  class Railtie < Rails::Railtie
    initializer "mongo.rails.instrumentation" do |app|
      instrument Mongo::Connection

      ActiveSupport.on_load(:action_controller) do
        include ControllerRuntime
      end

      LogSubscriber.attach_to :mongo
    end

    def instrument(clazz)
      clazz.module_eval do
        class_eval %|
          def instrument_with_instrumentation(name, payload={})
            payload[:name] = name
            res = nil
            ActiveSupport::Notifications.instrumenter.instrument("mongo.mongo", payload) { res = yield }
            res
          end
        |

        alias_method_chain :instrument, :instrumentation
      end
    end
  end
end
