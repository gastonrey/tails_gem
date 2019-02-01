# frozen_string_literal: true

require 'securerandom'
require 'helpers/parsers'
require 'helpers/slogger'
require 'helpers/errors'
require 'worker'

module Tails
  class Subscribers
    include Helpers::Parsers

    attr_reader :message

    def initialize(worker, config_file_path)
      unless config_file_path
        raise Helpers::SubscriberErrors::NoYamlConfigFile.new
      end

      @logger = Helpers::Slogger.new.log
      @subscriber_config = 
        load_configuration_from(config_file_path)
    
      setup_worker_and_event_type(worker)
      subscribe_and_dispatch
    end

    def subscribe_and_dispatch
      raise Helpers::SubscriberErrors::TopicNotFound unless @event_type

      subscribe(@event_type) do |message|
        @message = message
        @worker.perform(message) if valid?(message)
      end
      client.join
    end

    private

    def setup_worker_and_event_type(worker)
      @worker = Object.const_get(worker).new rescue nil
      raise Helpers::SubscriberErrors::NoNameSpaceProvided.new unless @worker

      @event_type = @worker.event_type
      raise EventTypeNotPresent.new unless @event_type
    end

    def subscribe(event)
      client.subscribe(build_queue_name(event, @worker),
                       id: SecureRandom.uuid,
                       ack: 'client-individual') do |message|

        @logger.info("Subscribed to #{event}. "\
                     "Received message #{message.body}")

        yield message
      end
    end

    def client
      @subscriber_config[:logger] = @logger
      @client ||= Stomp::Client.new(@subscriber_config)
    rescue  Timeout::Error,
            Errno::EINVAL,
            Errno::ECONNRESET => e

      raise Helpers::SubscriberErrors::StompConnectionError, e
    end

    def valid?(message)
      if message.nil? || message.command == 'ERROR'
        @logger.warn("Message with errors found: \n" \
                    "#{message.inspect}")
        return false
      end
      true
    end
  end
end
