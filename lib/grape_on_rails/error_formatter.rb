module GrapeOnRails
  module ErrorFormatter
    def render_error error_name, message, http_status
      render json: {
        GoR.error_code_key => GoR.errors.public_send(error_name).code,
        GoR.error_message_key => message
      }, status: http_status
    end
  end
end
