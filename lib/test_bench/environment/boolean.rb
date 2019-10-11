module TestBench
  module Environment
    module Boolean
      Error = Class.new(RuntimeError)

      def self.fetch(env_var, default_value=nil, env: nil)
        value = get(env_var, env: env)

        return default_value if value.nil?

        value
      end

      def self.get(env_var, env: nil)
        env ||= ::ENV

        return nil unless env.key?(env_var)

        text_value = env.fetch(env_var)

        case text_value
        when true_pattern
          true
        when false_pattern
          false
        else
          raise Error, "Invalid boolean value for ENV variable #{env_var.inspect} (Value: #{text_value.inspect})"
        end
      end

      def self.true_pattern
        @true_pattern ||= %r{\A(?:on|yes|y|true|t|1)\z}ni
      end

      def self.false_pattern
        @false_pattern ||= %r{\A(?:off|no|n|false|f|0)\z}ni
      end
    end
  end
end
