require "grape_on_rails/models/user_actor"
require "grape_on_rails/models/user_token_actor"

module GrapeOnRails
  module Models
    DEFAULT_USER_ACTOR = "User"
    DEFAULT_USER_TOKEN_ACTOR = "UserToken"

    def acts_as model
      include GrapeOnRails::Models.const_get "#{model}_actor".classify
      missing_columns = check_missing_columns
      raise "You need to add columns: #{missing_columns} to #{name} model" unless missing_columns.empty?
    end

    class << self
      def set_default_model_actors config
        config.models = StructuralHash.new.from_hash default_model_actors unless config.models
      end

      def default_model_actors
        {
          user: DEFAULT_USER_ACTOR,
          user_token: DEFAULT_USER_TOKEN_ACTOR
        }
      end
    end
  end
end
