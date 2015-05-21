require 'faraday'
require 'faraday_middleware'
# require 'spore/error'
require 'spore/version'
require 'spore/client/users'
require 'spore/client/cells'
require 'spore/client/apps'
# require 'spore/response/parse_json'
# require 'spore/response/raise_error'

module Spore

  class Client
    include Spore::Client::Users
    include Spore::Client::Cells
    include Spore::Client::Apps

    attr_reader :email
    attr_reader :name
    attr_reader :key
    attr_reader :current_user

    attr_accessor :api_endpoint
    attr_accessor :user_agent
    attr_accessor :middleware

    def initialize(email = nil, key = nil)
      @email = email
      @key = key
    end

    def api_endpoint
      @api_endpoint ||= 'http://pod.spore.sh/'
    end

    def user_agent
      @user_agent ||= "Spore #{Spore::Version.to_s}"
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
      request(:get, path, params)
    end

    def post(path, params = nil)
      request(:post, path, params)
    end

    def patch(path, params = nil)
      request(:patch, path, params)
    end

    def delete(path, params = nil)
      request(:delete, path, params)
    end

    def request(method, path, parameters = {})
      response = connection.send(method.to_sym, path, parameters)
      if error = response.body["error"]
        raise error["message"]
      end
      response
    rescue Faraday::Error::ClientError
      raise Spore::RequestError
    end

    def connection
      Faraday.new(api_endpoint) do |conn|
        conn.basic_auth(email, key) if signed_in?
        conn.request :url_encoded
        conn.response :json, :content_type => /\bjson$/
        conn.adapter  Faraday.default_adapter
        conn.headers[:user_agent] = user_agent
      end
    end

  end
end