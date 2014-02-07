puts "WARNING: Monkey patch for Faraday loaded, only needed on developer machines"

# Monkey patch Faraday so it honours NO_PROXY environment variables.
# I'm so sorry.
#
# Unlike Net::HTTP, Faraday honours the environment set HTTP_PROXY and
# HTTPS_PROXY variables. Unfortunately, it doesn't support NO_PROXY
# variables; so you end up with localhost requests hitting the proxy, 
# which sucks.
#
# There's an open pull request on Faraday: https://github.com/lostisland/faraday/pull/247
# Unfortunately, we can't just pull that in because Hyperclient hasn't been
# updated to support the newer version of Faraday which this fork is of.
#
# Ugh.
module Faraday
  class Connection
    def build_request(method)
      Request.create(method) do |req|
        req.params  = self.params.dup
        req.headers = self.headers.dup
        req.options = self.options.merge(:proxy => self.proxy)
        
        yield req if block_given?

        req.options.delete(:proxy) if no_proxy? req.path
      end
    end

    def no_proxy? path
      (ENV['no_proxy'] || ENV['NO_PROXY']).include? URI.parse(path).host
    end
  end
end
