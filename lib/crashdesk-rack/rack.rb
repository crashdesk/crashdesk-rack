module CrashdeskRack
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        status, headers, body = @app.call(env)
      rescue Exception => exception
        $stdout.puts "Crashdesk rack rescue: #{exception.message}"

        request = ::Rack::Request.new(env)
        context = RackContext.new(env, request)

        begin
          crashlog = Crashdesk.crashlog(exception, request, context)
          crashlog.report

          env['crashdesk.crashlog_crc'] = crashlog.crc
        rescue Exception => e
          $stderr.puts "Crashdesk can has a bug: #{e.message}"
          $stderr.puts "Backtrace: ", e.backtrace
        end

        raise exception
      end

      [status, headers, body]
    end
  end
end

