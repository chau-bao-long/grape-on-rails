module GrapeOnRails
  module Validator
    extend ActiveSupport::Concern

    include GrapeOnRails::Macros

    ALLOW_ACTIONS = /(create|update|destroy|index|show)/

    class_methods do
      def validate_actions *actions
        actions.each do |action|
          meta_method = "before_action :validate_#{action}, only: :#{action}"
          class_eval meta_method
        end
      end

      def method_missing method, *args, &block
        action = extract_action method
        super unless action&.match? ALLOW_ACTIONS
        define_method "hook_#{action}", block
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          before_action :hook_#{action}, only: :#{action}
        RUBY
      end

      def respond_to_missing? method_name, include_private = false
        extract_action(method_name)&.match?(ALLOW_ACTIONS) || super(method_name, include_private)
      end

      def extract_action method_name
        method_name[/.+?(?=_params)/]
      end
    end
  end
end
