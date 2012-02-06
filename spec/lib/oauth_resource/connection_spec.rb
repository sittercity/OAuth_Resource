require 'spec_helper'
require 'active_resource/exceptions'

describe OauthResource::Resource do

  context "making an active resource request" do

    before(:all) do
      builder = DummyResource.connection.http.builder
      @stubs = Faraday::Adapter::Test::Stubs.new
      builder.swap(-1, Faraday::Adapter::Test, @stubs)
    end

    context "ActiveResource http methods" do

      it "can successfully call ActiveResource methods" do
        @stubs.get('/dummy_resources/1.json') do |env|
          [200, {}, {:dummy_resource => {:id => 1}}.to_json]
        end
        DummyResource.find(1).should_not be_nil
      end

      it "can pass additional GET parameters" do
        @stubs.get('/dummy_resources.json') do |env|
          env[:params]['active'].should == '1'
          [200, {}, {:dummy_resources => [] }.to_json]
        end

        DummyResource.find(:all, :params => { :active => 1 })
      end

      it "can pass along the body in a POST request" do
        @stubs.post('/dummy_resources.json') do |env|
          [201, { 'Location' => 'http://example.com/dummy_resources/1' },
                {:dummy_resource => {:id => 1, :active => '1' }}.to_json]
        end

        DummyResource.create(:active => 1).should_not be_nil
      end
    end

    context "OAuth headers" do

      it "sets the Auth header correctly" do
        @stubs.get('/dummy_resources/1.json') do |env|

          auth_header = SimpleOAuth::Header.parse(env[:request_headers]['Authorization'])
          auth_header[:consumer_key].should == DUMMY_CONSUMER_KEY
          auth_header[:nonce].should_not be_nil
          auth_header[:signature].should_not be_nil
          auth_header[:signature_method].should == "HMAC-SHA1"
          auth_header[:timestamp].should_not be_nil
          auth_header[:version].should == "1.0"

          [200, {}, {:dummy_resource => { :id => 1 }}.to_json]
        end

        DummyResource.find(1)
      end

    end

    context "error handling" do

      # ARes connection#handle_request handles all relevant http status codes. This test
      # ensures that the response is correctly being handed off to ARes for error handling

      context "typical ARes POS" do

        it "uses ActiveResource::Connection#request for http error code handling" do
          @stubs.post('/dummy_resources.json') do |env|
            [401, {}, "Unauthorized"]
          end
          lambda { DummyResource.create(:active => 1) }.should raise_exception(ActiveResource::UnauthorizedAccess)
        end

      end

      context "typical ARes GET" do

        it "uses ActiveResource::Connection#request for http error code handling" do
          @stubs.get('/dummy_resources/2.json') do |env|
            [404, {}, "Not found"]
          end
          lambda { DummyResource.find(2) }.should raise_exception(ActiveResource::ResourceNotFound)
        end

      end
    end
  end
end
