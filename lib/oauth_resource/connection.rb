# Please see LICENSE.txt for copyright and license information.

require 'faraday'
require 'simple_oauth'
require 'faraday_middleware'
require 'faraday_middleware/request/oauth'

# Subclass of ActiveResource::Connection that uses faraday middleware to sign requests
#
module OauthResource
  class Connection < ::ActiveResource::Connection

    attr_accessor :consumer_key, :consumer_secret

    def self.adapter
      @adapter ||= Faraday.default_adapter
    end

    def self.adapter=(adapter)
      @adapter = adapter
    end

    # Create a new Faraday connection object using faraday_middleware's oauth signing
    #
    def http
      @http ||= Faraday.new(:url => site) do |conn|
        conn.request :oauth, :consumer_key => consumer_key, :consumer_secret => consumer_secret
        conn.adapter self.class.adapter
      end
    end

    # Wrap a faraday GET request in ARes request method for error handling
    # and ActiveSupport::Notifications instrument support
    #
    def get(path, headers = {})
      request(:get, path, {}, http_format_header(:get).merge(headers))
    end

    # Wrap a faraday DELETE request in ARes request method for error handling
    # and ActiveSupport::Notifications instrument support
    #
    def delete(path, headers = {})
      request(:delete, path, {}, http_format_header(:delete).merge(headers))
    end

    # Wrap a faraday PUT request in ARes request method for error handling
    # and ActiveSupport::Notifications instrument support
    #
    def put(path, body = '', headers = {})
      request(:put, path, body, http_format_header(:put).merge(headers))
    end

    # Wrap a faraday POST request in ARes request method for error handling
    # and ActiveSupport::Notifications instrument support
    #
    def post(path, body = '', headers = {})
      request(:post, path, body, http_format_header(:post).merge(headers))
    end

    # Wrap a faraday HEAD request in ARes request method for error handling
    # and ActiveSupport::Notifications instrument support
    #
    def head(path, headers = {})
      request(:head, path, {}, http_format_header(:head).merge(headers))
    end

  end
end
