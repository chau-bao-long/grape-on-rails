module GrapeOnRails
  module Integrations
    class Railtie < Rails::Railtie
      def auto_reload_in_development
        return unless ::Rails.env.development? && ::Rails::VERSION::MAJOR >= 4
        reload_on_api_only_mode
        reload_on_normal_mode
      end

      def reload_on_api_only_mode
        ActionController::Base.class_eval(&reload_on_each_request)
      end

      def reload_on_normal_mode
        ActionController::API.class_eval(&reload_on_each_request)
      end

      def reload_on_each_request
        proc do
          prepend_before_action{::GrapeOnRails.reload}
        end
      end

      config.before_configuration{GrapeOnRails.load}

      config.after_initialize do
        ActiveSupport.on_load(:active_record) do
          extend GrapeOnRails::Models
        end
        ActiveSupport.on_load(:action_controller) do
          include GrapeOnRails::API
          include GrapeOnRails::Authenticator
        end
        auto_reload_in_development
      end
    end
  end
end
