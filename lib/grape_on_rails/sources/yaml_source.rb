require "yaml"
require "erb"

module GrapeOnRails
  module Sources
    class YAMLSource
      attr_accessor :path

      def initialize path
        @path = path
      end

      def load
        @path && File.exist?(@path.to_s) ? YAML.safe_load(ERB.new(IO.read(@path.to_s)).result) : {}
      rescue Psych::SyntaxError => e
        raise "YAML syntax error occurred while parsing #{@path}. " \
          "Error: #{e.message}"
      end
    end
  end
end
