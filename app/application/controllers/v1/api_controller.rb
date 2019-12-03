# frozen_string_literal: true

module Controllers
  module V1
    # UsersController class contains User related endpoints
    class ApiController < ActionController::API
      def json_api
        @json_api ||= JSONAPI::Serializable::Renderer.new
      end
    end
  end
end
