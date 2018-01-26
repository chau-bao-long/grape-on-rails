require "grape_on_rails/error_formatter"
require "grape_on_rails/validator"

module GrapeOnRails
  module API
    extend ActiveSupport::Concern

    include ActiveSupport::Rescuable
    include Validator
    include ErrorFormatter
    include Support

    included do
      rescue_from APIError::Base do |e|
        render_error class_name(e), e.message, e.status
      end

      rescue_from ActiveRecord::UnknownAttributeError, ActiveRecord::StatementInvalid, JSON::ParserError do |e|
        render_error :data_operation, e.message, :internal_server_error
      end

      rescue_from ActiveRecord::RecordNotFound do
        render_error :record_not_found, gor_t("record_not_found"), :bad_request
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        render_error :record_invalid, e.message, :bad_request
      end

      private
      def r resources, extra_params = {}
        render extra_params.merge json: resources
      end
    end
  end
end
