module GrapeOnRails
  module Authenticator
    include Support

    attr_accessor :current_user

    def authenticate!
      @current_user = GoR.models.user_token.constantize
        .find_token!(token_on_header)&.public_send(GoR.models.user.downcase)
      raise APIError::Unauthenticated unless current_user
    end

    def refresh_token!
      token = GoR.models.user_token.constantize.find_by refresh_token: token_on_header
      token ? token.renew! : raise(APIError::Unauthenticated)
      token
    end

    def token_on_header
      auth_header = request.headers[GoR.access_token_header]
      auth_header&.scan(/^#{GoR.access_token_value_prefix} (.+)$/i)&.flatten&.[]0
    end
  end
end
