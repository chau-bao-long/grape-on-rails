module GrapeOnRails
  module Models
    module UserTokenActor
      extend ActiveSupport::Concern
      include Support
      include SecuredGenerator

      included do
        has_secure_token
        has_secure_token :refresh_token

        def renew! remember = false
          update! expires_at: GoR.token_configs.public_send(remember ? :expires_in : :short_expires_in).second.from_now,
            token: unique_random(:token), refresh_token: unique_random(:refresh_token)
          self
        end

        def expired?
          expires_at <= Time.zone.now
        end

        def expires!
          update_attributes! expired_at: Time.zone.now
        end
      end

      class_methods do
        def generate! user
          token = find_or_initialize_by GoR.models.user.downcase => user
          token.renew!
        end

        def find_token! token
          find_by(token: token).tap do |user_token|
            raise APIError::TokenExpired if user_token&.expired?
          end
        end

        def check_missing_columns
          %w(token refresh_token expires_at) - column_names
        end
      end
    end
  end
end
