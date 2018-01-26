module GrapeOnRails
  module Models
    module UserActor
      extend ActiveSupport::Concern

      included do
        has_secure_password
      end

      class_methods do
        def authenticate! email, password
          find_by(email: email).tap do |user|
            raise APIError::WrongEmailPassword unless user&.authenticate password
          end
        end

        def check_missing_columns
          %w(email password_digest) - column_names
        end
      end
    end
  end
end
