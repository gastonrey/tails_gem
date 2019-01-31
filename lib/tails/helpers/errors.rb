# frozen_string_literal: true

module Helpers
  module SubscriberErrors
    module_function

    def logger
      @logger ||= Slogger.new.log
    end

    class TopicNotFound < StandardError; end

    class RequestError < StandardError
      def initialize(url, response)
        SubscriberErrors.logger.error(
          "ERROR Trying to make a request to: #{url} \n" \
          "Server response message: \n" \
          "#{response.return_message}\n" \
          "Response Code: #{response.response_code}"
        )
      end
    end

    class StompConnectionError < StandardError
      def initialize(error)
        SubscriberErrors.logger.error(
          'Connection error, could not subscribe to events. ' \
          "Please check activeMQ configurations \n" \
          "Error: #{error.message}"
        )
      end
    end

    class ErrorParsingBody < StandardError
      def initialize(body)
        SubscriberErrors.logger.error("Error parsing body: \n\t #{body}")
      end
    end
  end
end
