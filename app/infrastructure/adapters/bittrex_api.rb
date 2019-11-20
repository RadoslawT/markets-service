# frozen_string_literal: true

module Adapters
  # :nodoc:
  class BittrexApi
    API_HOST = 'api.bittrex.com'
    API_VERSION = 'v3'
    class << self
      def markets_tickers
        json_body = request('/markets/tickers')

        json_body.map do |market|
          {
            bid_rate: market['bidRate'].to_f,
            ask_rate: market['askRate'].to_f,
            symbol: market['symbol']
          }
        end
      end

      private

      def request(path)
        response = Faraday.get api_url(path)

        raise InfrastructureErrors::BadResponse unless response.status == 200

        JSON.parse(response.body)
      end

      def api_url(path)
        'https://' + API_HOST + '/' + API_VERSION + path
      end
    end
  end
end
