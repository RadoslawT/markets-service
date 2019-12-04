# frozen_string_literal: true

module Controllers
  module V1
    # ApiController base class
    class ApiController < ActionController::API
      def json_api
        @json_api ||= JSONAPI::Serializable::Renderer.new
      end
    end
  end
end
