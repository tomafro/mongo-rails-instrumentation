require 'mongo/rails/instrumentation'

module Mongo::Rails::Instrumentation
  class Railtie < Rails::Railtie
    initializer "mongo.rails.instrumentation" do |app|
      instrument Mongo::Networking, [
        :send_message,
        :send_message_with_safe_check,
        :receive_message
      ]

      ActiveSupport.on_load(:action_controller) do
        include ControllerRuntime
      end

      LogSubscriber.attach_to :mongo
    end

    def instrument(clazz, methods)
      clazz.module_eval do
        methods.each do |m|
          class_eval <<-CODE, __FILE__, __LINE__ + 1
            def #{m}_with_instrumentation(*args, &block)
              ActiveSupport::Notifications.instrumenter.instrument "mongo.mongo", :name => "#{m}" do
                #{m}_without_instrumentation(*args, &block)
              end
            end
          CODE

          alias_method_chain m, :instrumentation
        end
      end
    end
  end
end
