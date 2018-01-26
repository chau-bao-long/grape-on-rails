require "i18n"

module GrapeOnRails
  module Support
    def gor_translate error
      GoR.errors.public_send(error).public_send(I18n.locale)
    end
    alias_method :gor_t, :gor_translate

    def class_name instance
      instance.class.name.demodulize.underscore
    end
  end
end
