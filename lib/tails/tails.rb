# frozen_string_literal: true

require 'securerandom'
require 'tails/helpers/parsers'
require 'tails/helpers/slogger'
require 'tails/helpers/errors'
require 'tails/worker'

module Tails
  class Subscribers
    include Helpers::Parsers

    attr_reader :message, :worker

    def initialize(worker, config_file_path)
      unless config_file_path
        raise Helpers::SubscriberErrors::NoYamlConfigFile.new
      end

      @subscriber_config = 
        load_configuration_from(config_file_path)
      
      @logger = Helpers::Slogger.new(
        @subscriber_config.fetch(:log_file, nil)
      ).log
      
      setup_worker_and_event_type(worker)
      subscribe_and_dispatch
    end

    def subscribe_and_dispatch
      raise Helpers::SubscriberErrors::TopicNotFound unless @event_type

      subscribe(@event_type) do |message|
        @message = message
        begin
          if valid?(message)
            @worker.perform(message.body)
            client.ack message
          end
        rescue Exception => e
          raise Helpers::SubscriberErrors::ErrorPerformingMessage, e
        end
      end
      client.join
    end

    private

    def setup_worker_and_event_type(worker)
      @worker = Object.const_get(worker).new rescue nil
      raise Helpers::SubscriberErrors::NoNameSpaceProvided.new unless @worker

      @event_type = @worker.event_type rescue nil
      raise Helpers::SubscriberErrors::EventTypeNotPresent.new unless @event_type
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
            Errno::ECONNRESET,
            Stomp::Error::MaxReconnectAttempts => e

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
