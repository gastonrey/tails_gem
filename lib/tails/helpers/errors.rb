# frozen_string_literal: true

module Tails
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

      class NoNameSpaceProvided < StandardError
        def initialize
          SubscriberErrors.logger.error(
            "Please provide an existing name space, i.e: Module::ClassName")
        end
      end
      
      class EventTypeNotPresent < StandardError
        def initialize
          SubscriberErrors.logger.error(
            "Please provide an existing event type in ActiveMQ")
        end
      end

      class NoYamlConfigFile < StandardError
        def initialize
          message = "tails.yml config file is not present. " \
                    "Create one and setup there all the info to be subscribed"
          
          super(message)
          SubscriberErrors.logger.error(message)
        end
      end

      class ErrorPerformingMessage < StandardError
        def initialize(e)
          message = "Error trying to perform with message: \n" \
                    "\t Exception: #{e.message}"
          
          super(message)
          SubscriberErrors.logger.error(message)
        end
      end
    end
  end
end
