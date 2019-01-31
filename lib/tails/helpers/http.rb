# frozen_string_literal: true

module Helpers
  module HTTP
    TIME_OUT = 5

    def get(url)
      response = Typhoeus.get(url,
                              timeout: TIME_OUT,
                              headers: { content_type: 'application/json' })

      unless response.success?
        raise Helpers::SubscriberErrors::RequestError.new(
          url, response
        )
      end

      HTTPResponses.as_hash(response)
    end

    def post(url, body)
      response = Typhoeus.post(url,
                               timeout: TIME_OUT,
                               body: body.to_json,
                               headers: { content_type: 'application/json' })

      unless response.success?
        raise Helpers::SubscriberErrors::RequestError.new(
          url, response
        )
      end

      HTTPResponses.as_hash(response)
    end

    module_function :get, :post
  end

  module HTTPResponses
    module_function

    def as_hash(response)
      { ok: response.success?,
        body: JSON.parse(response.body),
        res: response }
    rescue JSON::ParserError
      raise Helpers::SubscriberErrors::ErrorParsingBody, response.body
    end
  end
end
