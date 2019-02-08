# frozen_string_literal: true

require 'logger'
require 'stomp'

module Tails
  module Helpers
    # A logger class may optionally inherit from the provided NullLogger
    #
    # # class Slogger < Stomp::NullLogger
    #
    class Slogger < ::Stomp::NullLogger
      attr_reader :log

      # Initialize a new callback logger instance.
      def initialize(file_path = nil)
        _init(file_path)
        @log.info('Logger initialization complete.')
      end

      def _init(file_path)
        output = file_path.nil? ? STDOUT : file_path
        @log ||= ::Logger.new(output)
        @log.level = Logger::DEBUG
      end

      def marshal_dump
        []
      end

      def marshal_load(_array)
        _init
      end

      # Log connectfail events
      def on_connectfail(parms)
        @log.debug "Connect Fail #{info(parms)}"
      rescue StandardError
        @log.debug 'Connect Fail oops'
      end

      # Log Ack
      def on_ack(parms, headers)
        @log.debug "Ack Parms #{info(parms)}"
        @log.debug "Ack Result #{headers}"
      rescue StandardError
        @log.debug 'Ack oops'
      end

      # Log NAck
      def on_nack(parms, headers)
        @log.debug "NAck Parms #{info(parms)}"
        @log.debug "NAck Result #{headers}"
      rescue StandardError
        @log.debug 'NAck oops'
      end

      # Log an unsuccessful SSL connect.
      def on_ssl_connectfail(parms)
        @log.debug "SSL Connect Fail Parms #{info(parms)}"
        @log.debug "SSL Connect Fail Exception #{parms[:ssl_exception]}, " \
                  "#{parms[:ssl_exception].message}"
      rescue StandardError
        @log.debug 'SSL Connect Fail oops'
      end

      private

      # Example information extract.
      def info(parms)
        #
        # Available in the parms Hash:
        # parms[:cur_host]
        # parms[:cur_port]
        # parms[:cur_login]
        # parms[:cur_passcode]
        # parms[:cur_ssl]
        # parms[:cur_recondelay]
        # parms[:cur_parseto]
        # parms[:cur_conattempts]
        # parms[:openstat]
        #
        # For the on_ssl_connectfail callback these are also available:
        # parms[:ssl_exception]
        #
        "Host: #{parms[:cur_host]}, " \
        "Port: #{parms[:cur_port]}, " \
        "Login: #{parms[:cur_login]}, " \
        "Passcode: #{parms[:cur_passcode]}, " \
        "ssl: #{parms[:cur_ssl]}"
      end
    end
  end
end
