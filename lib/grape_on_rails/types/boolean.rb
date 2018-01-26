module GrapeOnRails
  module Types
    module Boolean
      def to_b
        case self
        when "true"
          true
        when "false"
          false
        end
      end
    end
  end
end

class TrueClass
  include GrapeOnRails::Types::Boolean
end
class FalseClass
  include GrapeOnRails::Types::Boolean
end
