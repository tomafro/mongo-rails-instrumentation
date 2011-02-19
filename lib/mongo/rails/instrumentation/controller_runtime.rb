require 'mongo/rails/instrumentation'

module Mongo::Rails::Instrumentation
  module ControllerRuntime
    extend ActiveSupport::Concern

    protected

    attr_internal :mongo_runtime

    def cleanup_view_runtime
      mongo_rt_before_render = LogSubscriber.reset_runtime
      runtime = super
      mongo_rt_after_render = LogSubscriber.reset_runtime
      self.mongo_runtime = mongo_rt_before_render + mongo_rt_after_render
      runtime - mongo_rt_after_render
    end

    def append_info_to_payload(payload)
      super
      payload[:mongo_runtime] = mongo_runtime
    end

    module ClassMethods
      def log_process_action(payload)
        messages, mongo_runtime = super, payload[:mongo_runtime]
        messages << ("Mongo: %.1fms" % mongo_runtime.to_f) if mongo_runtime
        messages
      end
    end
  end
end