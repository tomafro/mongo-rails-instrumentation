require 'mongo/rails/instrumentation'

class Mongo::Rails::Instrumentation::LogSubscriber < ActiveSupport::LogSubscriber
  RUNTIME_KEY = name + "#runtime"
  COUNT_KEY = name + "#count"

  def self.runtime=(value)
    Thread.current[RUNTIME_KEY] = value
  end

  def self.runtime
    Thread.current[RUNTIME_KEY] ||= 0
  end

  def self.count=(value)
    Thread.current[COUNT_KEY] = value
  end

  def self.count
    Thread.current[COUNT_KEY] ||= 0
  end

  def self.reset_runtime
    rt, self.runtime, self.count = runtime, 0, 0
    rt
  end

  def mongo(event)
    self.class.runtime += event.duration
    self.class.count += 1
  end
end