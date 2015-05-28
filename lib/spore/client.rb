require 'faraday'
require 'faraday_middleware'

require 'spore/version'
require 'spore/client/users'
require 'spore/client/cells'
require 'spore/client/apps'
require 'spore/client/deployments'
require 'spore/client/memberships'

module Spore
  class RequestError < StandardError; end

  class Client
    include Spore::Client::Users
    include Spore::Client::Cells
    include Spore::Client::Apps
    include Spore::Client::Deployments
    include Spore::Client::Memberships

    attr_accessor :email
    attr_accessor :key

    attr_accessor :api_endpoint
    attr_accessor :user_agent
    attr_accessor :middleware

    def initialize(email = nil, key = nil)
      @email = email
      @key = key
    end

    def name=(deployment_name)
      @email = deployment_name
    end

    def api_endpoint
      @api_endpoint ||= 'https://pod.spore.sh/'
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

    def post(path, params, options = nil)
      request(:post, path, params, options)
    end

    def patch(path, params, options = nil)
      request(:patch, path, params, options)
    end

    def delete(path, params = nil)
      request(:delete, path, params)
    end

    def request(method, path, parameters = {}, options = nil)
      response = connection.send(method.to_sym, path, parameters) do |req|
        req.headers["Prefer"] = 'respond-async' if options && options[:async]
      end
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