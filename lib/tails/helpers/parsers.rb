# frozen_string_literal: true

require 'json'
require 'erb'
require 'yaml'

module Tails
  module Helpers
    module Parsers
      module_function

      def load_configuration_from(file)
        content = raw_data(file)
        begin
          parsed_config = YAML.safe_load(content, [], [], true)
          JSON.parse(
            parsed_config[ENV.fetch('RACK_ENV', 'development')].to_json,
            :symbolize_names => true)
        rescue TypeError
          raise "Error could not load YAML: #{file}"
        end
      end

      def raw_data(file)
        raw_yaml = File.open(file).read
        ERB.new(raw_yaml).result
      rescue Errno::ENOENT
        raise "Could not open file: #{file}"
      end

      def parse(body)
        JSON.parse(body)
      rescue JSON::ParserError
        raise Helpers::SubscriberErrors::ErrorParsingBody, body
      end

      def build_queue_name(event_type, klass)
        if event_type.include? '::'
          event_type = event_type.split('::').map(&:capitalize).join
        end

        "Consumer.#{klass.class.name.gsub('::', '_')}.VirtualTopic.#{event_type}"
      end
    end
  end
end
