# frozen_string_literal: true

require_all File.dirname(__FILE__) + '/helpers'

Bundler.require(:default, ENV.fetch('RACK_ENV', 'development'))

module Subscribers
  class Base
    include Helpers::HTTP
    include Helpers::Parsers

    attr_reader :message,
                :data_message

    def initialize
      @subscriber_config = load_configuration_from('config/tails.yml')
      @topics = load_configuration_from('config/topics.yml')
      @logger = Helpers::Slogger.new.log
    end

    def dispatch(_message)
      raise NotImplementedError, 'Implement this method in a child class'
    end

    def subscribe_and_dispatch(topic)
      raise Helpers::SubscriberErrors::TopicNotFound unless @topics[topic]

      subscribe(topic) do |message|
        @message = message
        @data_message = parse(message.body)['data']
        dispatch(message) if valid?(message)
      end
      client.join
    end

    private

    def subscribe(topic)
      client.subscribe(@topics[topic], id: SecureRandom.uuid,
                                       ack: 'client-individual') do |message|

        @logger.info("Subscribed to #{@topics[topic]}. "\
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
