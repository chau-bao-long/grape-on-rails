module GrapeOnRails
  module Attributes
    TYPE = {BigDecimal: "to_d", DateTime: "to_datetime", Date: "to_date", Time: "to_time"}.freeze

    def declared_attrs attrs
      @declared_attrs ||= []
      @declared_attrs |= attrs
    end

    def declared_params
      params.permit @declared_attrs
    end

    def undeclare_params *params
      @declared_attrs -= params
    end

    private
    def verify method, attrs, value
      attrs.each do |attr|
        is_valid = send "verify_#{method}", attr, value
        raise APIError::ValidationError, "#{attr} #{I18n.t "errors.messages.#{method}"}" unless is_valid
        instance_variable_set "@#{attr}".to_sym, params[attr]
        self.class.class_eval{attr_reader attr}
      end
    end

    def verify_type attr, type, param = nil
      return verify_type_in_array attr, type if type.is_a? Array
      return true if type == File
      param ||= params[attr]
      param.class.include GrapeOnRails::Types::Boolean if type == GrapeOnRails::Types::Boolean
      convert_method = TYPE[type.name.to_sym] || "to_#{type.name[0].downcase}"
      params[attr] = param.public_send convert_method
      true
    rescue StandardError
      false
    end

    def verify_type_in_array attr, type
      params[attr].all?{|p| verify_type(attr, type.to_a.first, param: p)}
    end

    def verify_allow_blank attr, is_allow
      params[attr].present? || is_allow
    end

    def verify_regexp attr, regex
      params[attr] =~ regex
    end
  end
end
