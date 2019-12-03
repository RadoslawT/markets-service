# frozen_string_literal: true

module Controllers
  module V1
    # MarketsController class contains Market related endpoints
    class MarketsController < ApiController
      def index
        query_result = Queries::AllMarkets.call

        api_response = json_api.render(query_result, class: { 'Entities::Market': Serializers::Market })

        render json: api_response, status: :ok
      end
    end
  end
end
