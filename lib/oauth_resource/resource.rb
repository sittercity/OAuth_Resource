module OauthResource
  class Resource < ::ActiveResource::Base

    def self.connection(refresh=false)
      if defined?(@connection) || superclass == ::ActiveResource::Base
        @connection = OauthResource::Connection.new(site, format) if refresh || @connection.nil?
        @connection.consumer_key = consumer_key if consumer_key
        @connection.consumer_secret = consumer_secret if consumer_secret
        @connection.timeout = timeout if timeout
        @connection.ssl_options = ssl_options if ssl_options
        @connection
      else
        superclass.connection
      end
    end

    def self.consumer_key=(consumer_key)
      @connection = nil
      @consumer_key = consumer_key
    end

    def self.consumer_key
      if defined?(@consumer_key)
        @consumer_key
      elsif superclass != ActiveResource::Base && superclass.consumer_key
        superclass.consumer_key
      end
    end

    def self.consumer_secret=(consumer_secret)
      @connection = nil
      @consumer_secret = consumer_secret
    end

    def self.consumer_secret
      if defined?(@consumer_secret)
        @consumer_secret
      elsif superclass != ::ActiveResource::Base && superclass.consumer_secret
        superclass.consumer_key
      end
    end

    protected

    # This method is necessary since we're using faraday responses instead
    # of net/http responses. Faraday responses respond to #status, whereas net/http
    # responses respond to #code.
    #
    def load_attributes_from_response(response)
      if (response_code_allows_body?(response.status) &&
         (response['Content-Length'].nil? || response['Content-Length'] != "0") &&
         !response.body.nil? && response.body.strip.size > 0)

        load(self.class.format.decode(response.body), true)
        @persisted = true
      end
    end

  end
end
