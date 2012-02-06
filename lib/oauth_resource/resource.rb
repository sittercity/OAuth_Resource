# Please see LICENSE.txt for copyright and license information.

# A subclass of ActiveResource::Base for making transparent OAuth 1.0 requests
#
# Defined in a way to gracefully support multiple classes inheriting from the same
# OauthResource class
#
module OauthResource
  class Resource < ::ActiveResource::Base

    # Returns our ARes connection subclass for making signed requests.
    #
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

    # Set the consumer key for an OauthResource class
    #
    def self.consumer_key=(consumer_key)
      @connection = nil
      @consumer_key = consumer_key
    end

    # Retrieve the consumer key for an OauthResource class
    #
    def self.consumer_key
      if defined?(@consumer_key)
        @consumer_key
      elsif superclass != ActiveResource::Base && superclass.consumer_key
        superclass.consumer_key
      end
    end

    # Set the consumer secret for an OauthResource class
    #
    def self.consumer_secret=(consumer_secret)
      @connection = nil
      @consumer_secret = consumer_secret
    end

    # Retrieve the consumer secret for an OauthResource class
    #
    def self.consumer_secret
      if defined?(@consumer_secret)
        @consumer_secret
      elsif superclass != ::ActiveResource::Base && superclass.consumer_secret
        superclass.consumer_key
      end
    end

  end
end
