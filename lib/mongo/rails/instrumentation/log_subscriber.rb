require 'mongo/rails/instrumentation'

class Mongo::Rails::Instrumentation::LogSubscriber < ActiveSupport::LogSubscriber
  def self.runtime=(value)
    Thread.current["mongo_mongo_runtime"] = value
  end

  def self.runtime
    Thread.current["mongo_mongo_runtime"] ||= 0
  end

  def self.reset_runtime
    rt, self.runtime = runtime, 0
    rt
  end

  def mongo(event)
    self.class.runtime += event.duration
  end
end