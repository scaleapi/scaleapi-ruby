class ScaleApi
  class Api
    class Error < StandardError
      attr_accessor :status_code

      def initialize(message = 'Please double check the request was properly formed and try again', status_code = 400)
        super(message)
        self.status_code = status_code
      end
    end

    class BadRequest < Error
    end

    class TooManyRequests < Error
    end

    class NotFound < Error
    end

    class Unauthorized < Error
      def initialize(message = "Please ensure that the api_key provided is correct. To find your API key, go to your Scale Dashboard", status_code = 401)
        super(message, status_code)
      end
    end

    class InternalServerError < Error
      def initialize(message = "Scale's servers are currently experiencing issues. Please wait a moment and try again.", status_code = 500)
        super(message, status_code)
      end
    end

    class ConnectionError < Error
      def initialize(message = "There's an issue connecting to Scale's servers. Please check you're connected to the internet, and try again.'", status_code = nil)
        super(message, status_code)
      end
    end

    class APIKeyInvalid < Error
      def initialize(message = "Provided api_key is invalid. Please double check you passed it in correctly and try again. If you're having trouble finding it, check your Scale Dashboard", status_code = nil)
        super(message, status_code)
      end
    end

  end
end
