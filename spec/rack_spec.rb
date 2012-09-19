require 'spec_helper'

class FakeRackException < Exception; end
exception = Proc.new {|env| raise FakeRackException, 'For testing purpose' }
plain = Proc.new { |env| [200, {"Content-Type" => "text/html"}, "Hello Rack!"] }

Crashdesk.configure do |config|
  config.reporters = [:test]
end

describe CrashdeskRack::Rack do

  context "with one of the Rack middleware throwing exception" do
    before do
      @env = Rack::MockRequest.env_for('/hello')
      @app = Rack::Builder.new do
        use CrashdeskRack::Rack
        run exception
      end
    end

    it "should send the exception with Crashdesk crashlog reporter and re-raise" do
      -> {
        @app.call(@env)
      }.should raise_error FakeRackException, 'For testing purpose'
    end

    it "should insert into env crashdesk.crashlog_crc variable" do
      begin
        @app.call(@env)
      rescue FakeRackException
        @env.has_key?('crashdesk.crashlog_crc').should be_true
      end
    end
  end

  context "without throwing exception" do
    before do
      @env = Rack::MockRequest.env_for('/hello')
      @app = Rack::Builder.new do
        use CrashdeskRack::Rack
        run plain
      end
    end

    it "should pass the rack output" do
      -> {
       @status, @headers, @body =  @app.call(@env)
      }.should_not raise_error

      @status.should eq(200)
      @headers.should eq({"Content-Type" => "text/html"})
      @body.should eq('Hello Rack!')
    end
  end

end
