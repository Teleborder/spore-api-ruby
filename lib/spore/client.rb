require 'faraday'
# require 'spore/error'
require 'spore/version'
require 'spore/client/users'
# require 'spore/response/parse_json'
# require 'spore/response/raise_error'

module Spore

  class Client
    include Spore::Client::Users

    attr_reader :username
    attr_reader :current_user

    attr_accessor :api_endpoint
    attr_accessor :user_agent
    attr_accessor :middleware

    def initialize(username = nil, password = nil)
      @username = username
      @password = password

      sign_in(username, password) unless username.nil? || password.nil?
    end

    def api_endpoint
      @api_endpoint ||= 'http://pod.spore.sh/'
    end

    def user_agent
      @user_agent ||= "Spore. #{Spore::Version.to_s}"
    end

    def middleware
      @middleware ||= Faraday::RackBuilder.new do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use Spore::Response::RaiseError
        builder.use Spore::Response::ParseJSON
        builder.adapter Faraday.default_adapter
      end
    end

    private

    def get(path, params = nil)
      request(:get, path, params, connection)
    end

    def post(path, params = nil)
      request(:post, path, params, connection)
    end

    def put(path, params = nil)
      request(:put, path, params, connection)
    end

    def delete_path(path, params = nil)
      request(:delete, path, params, connection)
    end

    def request(method, path, parameters = {}, request_connection)
      if signed_in?
        request = authenticated_request_configuration(method, path, parameters)
        request_connection.send(method.to_sym, path, parameters, &request).env
      else
        request_connection.send(method.to_sym, path, parameters).env
      end
    rescue Faraday::Error::ClientError
      raise Spore::RequestError
    end

    def authenticated_request_configuration(method, path, parameters)
      fail Spore::NotAuthenticated unless signed_in?

      proc do |request|
      end
    end

    def connection
      @connection ||= 
        Faraday.new(api_endpoint) do |conn|
          conn.request :url_encoded
          conn.response :json, :content_type => /\bjson$/
          conn.adapter  Faraday.default_adapter
        end
    end

  end
end