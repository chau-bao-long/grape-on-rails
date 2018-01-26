module GrapeOnRails
  module Macros
    include GrapeOnRails::Attributes

    def requires *attrs
      options = attrs.extract_options!
      raise APIError::ValidationError if attrs.any?{|a| params[a].nil?}
      options.each{|k, v| verify k, attrs, v}
      declared_attrs attrs
    end

    def optional *attrs
      options = attrs.extract_options!
      return if attrs.any?{|a| params[a].nil?}
      options.each{|k, v| verify k, attrs, v}
      declared_attrs attrs
    end
  end
end
