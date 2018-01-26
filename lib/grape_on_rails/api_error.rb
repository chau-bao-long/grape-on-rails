module GrapeOnRails
  module APIError
    class Base < StandardError
      include Support

      attr_reader :status

      def initialize message = nil, status = nil
        super message || localize_message
        @status = status || :bad_request
      end

      private
      def localize_message
        gor_translate class_name(self)
      end
    end
  end
end
