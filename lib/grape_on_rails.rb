require "grape_on_rails/version"
require "active_support/dependencies/autoload"
require "active_support/core_ext/array/extract_options"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/concern"
require "grape_on_rails/sources/yaml_source"
require "grape_on_rails/structural_hash"
require "grape_on_rails/support"
require "grape_on_rails/types/boolean"

# rubocop:disable ModuleFunction, ClassVars
module GrapeOnRails
  extend ActiveSupport::Autoload
  extend self

  autoload :API
  autoload :APIError
  autoload :Authenticator
  autoload :Models
  autoload :SecuredGenerator

  mattr_accessor :config_file, :short_name

  @@_ran_once = false
  @@config_file = "grape_on_rails.yml"
  @@short_name = "GoR"

  def setup
    return if @@_ran_once
    @@_ran_once = true
    block_given? ? yield(self) : hook_rails_layers
  end

  def load
    config = load_file
    Kernel.send(:remove_const, short_name) if Kernel.const_defined?(short_name)
    Kernel.const_set short_name, config
    Models.set_default_model_actors config
    create_error_class config
  end

  alias :reload :load

  private
  def load_file
    file = Rails.root.join("config", config_file)
    source = Sources::YAMLSource.new(file.to_s).load
    StructuralHash.new.from_hash source
  end

  def create_error_class config
    config.errors.each do |error|
      next if error.second.skip_create_error
      error_name = error.first.to_s.classify
      APIError.const_set error_name, Class.new(APIError::Base) unless APIError.const_defined?(error_name)
    end
  end

  def hook_rails_layers
    hook_controller GrapeOnRails::API, GrapeOnRails::Authenticator
    hook_model GrapeOnRails::Models
  end

  def hook_controller *modules
    modules.each do |mod|
      ActionController::Metal.include mod unless ActionController::Metal < mod
    end
  end

  def hook_model *modules
    modules.each do |mod|
      ActiveRecord::Base.extend mod unless ActiveRecord::Base.singleton_class < mod
    end
  end
end
# rubocop:enable ModuleFunction, ClassVars

require("grape_on_rails/integrations/railtie") if defined?(::Rails)
