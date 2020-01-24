module TestBench
  module Controls
    module Fixture
      def self.example(output=nil, error_policy: nil)
        error_policy ||= self.error_policy

        fixture = Example.new

        TestBench::Fixture::ErrorPolicy.configure(fixture.test_session, policy: error_policy)

        unless output.nil?
          fixture.test_session.output = output
        end

        fixture
      end

      def self.example_class(&block)
        TestBench::Fixture::Controls::Fixture.example_class(&block)
      end

      def self.error_policy
        :rescue
      end

      Example = example_class
    end
  end
end
