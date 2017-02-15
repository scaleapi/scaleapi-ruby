require 'uri'
require 'faraday'
require 'json'

class Scale
  class Api < Struct.new(:api_key, :callback_auth_key, :default_request_params, :logging)
    SCALE_API_URL = 'https://api.scaleapi.com/v1/'

    def connection
      @connection ||= Faraday.new(:url => SCALE_API_URL) do |faraday|
        faraday.request  :basic_auth, self.api_key, ''
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger if logging       # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def get(url, params = {})
      response = connection.get do |req|
        req.url "#{SCALE_API_URL}#{url}"
        req.params.merge!(default_request_params.merge(params))
        req.headers['X-API-Client'] = "Ruby"
        req.headers["X-API-Client-Version"] = Scale::VERSION
      end

      if response.status != 200
        return handle_error(response)
      end

      response
    rescue Faraday::Error::ConnectionFailed
      raise Scale::Api::ConnectionError
    end

    def post(url, body = {})
      body = (default_request_params.merge(body))

      response = connection.post do |req|
        req.url "#{SCALE_API_URL}#{url}"
        req.headers['Content-Type'] = 'application/json'
        req.body = body.to_json
        req.headers['X-API-Client'] = "Ruby"
        req.headers["X-API-Client-Version"] = Scale::VERSION
      end

      if response.status != 200
        return handle_error(response)
      end

      response
    rescue Faraday::Error::ConnectionFailed
      raise Scale::Api::ConnectionError
    end

    def handle_error(response)
      error_body = JSON.parse(response.body)
      if response.status == 404
        raise Scale::Api::NotFound.new(error_body['error'], response.status)
      elsif response.status == 429
        raise Scale::Api::TooManyRequests.new(error_body['error'], response.status)
      elsif response.status > 499
        raise Scale::Api::InternalServerError.new(error_body['error'], response.status)
      elsif response.status == 401
        raise Scale::Api::Unauthorized.new(error_body['error'], response.status)
      else
        raise Scale::Api::BadRequest.new(error_body['error'], response.status)
      end
    rescue JSON::ParserError
      raise Scale::Api::InternalServerError
    end
  end
end

require 'scale/api/errors'
