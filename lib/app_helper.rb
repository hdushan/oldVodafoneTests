def error_message
  error_message = {
    'FUSION_TIMEOUT' => 'System timeout.',
    'ORDER_NOT_FOUND' => 'Order not found.',
    'ORDER_ID_EMPTY' => 'You must provide order number.',
    'INVALID_FORMAT' => 'Order id invalid.'
  }
  error_message.default = 'Internal error. Sorry'
  error_message
end

def cached_result(key, &block)
  if settings.cache
    settings.cache.fetch("#{ENV['RAILS_ENV']}-#{key}", {expire_in: ENV['CACHE_EXPIRE_TIME_SECONDS'] || 60}, &block)
  else
    yield
  end
end

def nil_or_empty? string
  string.nil? || string.empty?
end

def lookup_status_glyph(status)
  status_glyph = {
    'SHIPPED'           => 'tick',
    'PARTIALLY SHIPPED' => 'orange-tick',
    'CANCELLED'         => 'cross',
    'BACKORDERED'       => 'info',
    'IN PROGRESS'       => 'tick'
  }
  status_glyph.default = 'warning'
  status_glyph[status]
end

class Rack::CommonLogger
  alias_method :call_real, :call

  def call(env)
    if logging_required?(env)
      call_real(env)
    else
      @app.call(env)
    end
  end

  # return true if request should be logged
  def logging_required?(env)
    !LOGGING_BLACKLIST.include?(env['PATH_INFO'])
  end
end
