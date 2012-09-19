module CrashdeskRack
  class RackContext < Crashdesk::ContextBase

    def initialize(env, request)
      @env = env
      @request = request
    end

    def to_hash
      {
        'url' => request_url,
        'parameters' => parameters,
        'request_method' => request_method,
        'remote_ip' => remote_ip,
        'headers' => headers,
        'session' => session,
      }
    end

    def framework
      "rack"
    end

    def framework_version
      Rack.version # eq Rack::VERSION.join('.')
    end

    def request_url
      "#{@request.url}"
    end

    def parameters
      @request.params
    end

    def request_method
      @request.request_method.to_s
    end

    def remote_ip
      @request.ip
    end

    def headers
      extract_http_headers(@env)
    end

    def session
      extract_session(@request)
    end

  end
end
