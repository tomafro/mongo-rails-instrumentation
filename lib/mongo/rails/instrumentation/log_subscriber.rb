require 'mongo/rails/instrumentation'

class Mongo::Rails::Instrumentation::LogSubscriber < ActiveSupport::LogSubscriber
  RUNTIME_KEY = name + "#runtime"
  COUNT_KEY   = name + "#count"

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

  def initialize
    super
    @odd_or_even = false
  end

  def mongo(event)
    self.class.runtime += event.duration
    self.class.count += 1
    return unless logger.debug?

    payload = event.payload

    name    = 'MONGODB (%.1fms)' % [event.duration]
    query   = query_from_payload(payload)

    if odd?
      name   = color(name, CYAN, true)
      query  = color(query, nil, true)
    else
      name = color(name, MAGENTA, true)
    end

    debug "  #{name}  #{query}"
  end

  protected

  def query_from_payload(payload)
    msg = "#{payload[:database]}['#{payload[:collection]}'].#{payload[:name]}("
    msg += payload.values_at(:selector, :document, :documents, :fields ).compact.map(&:inspect).join(', ') + ")"
    msg += ".skip(#{payload[:skip]})"   if payload[:skip]
    msg += ".limit(#{payload[:limit]})" if payload[:limit]
    msg += ".sort(#{payload[:order]})"  if payload[:order]
    msg
  end

  def odd?
    @odd_or_even = !@odd_or_even
  end

  def logger
    Rails.logger
  end
end