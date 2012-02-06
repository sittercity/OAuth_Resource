# Please see LICENSE.txt for copyright and license information.

require 'faraday'
require 'simple_oauth'
require 'faraday_middleware'
require 'faraday_middleware/request/oauth'

module OauthResource
  class Connection < ::ActiveResource::Connection

    attr_accessor :consumer_key, :consumer_secret

    def self.adapter
      @adapter ||= Faraday.default_adapter
    end

    def self.adapter=(adapter)
      @adapter = adapter
    end

    def http
      @http ||= Faraday.new(:url => site) do |conn|
        conn.request :oauth, :consumer_key => consumer_key, :consumer_secret => consumer_secret
        conn.adapter self.class.adapter
      end
    end

    def get(path, headers = {})
      http.get(path, {}, http_format_header(:get).merge(headers))
    end

    def delete(path, headers = {})
      http.delete(path, {}, http_format_header(:delete).merge(headers))
    end

    def put(path, body = '', headers = {})
      http.put(path, body, http_format_header(:put).merge(headers))
    end

    def post(path, body = '', headers = {})
      http.post(path, body, http_format_header(:post).merge(headers))
    end

    def head(path, headers = {})
      http.head(path, {}, http_format_header(:head).merge(headers))
    end

  end
end
