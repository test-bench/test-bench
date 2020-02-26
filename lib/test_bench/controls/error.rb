module TestBench
  module Controls
    Error = TestBench::Fixture::Controls::Error

    module Error
      module Text
        def self.example(message=nil, indentation_depth: nil)
          indentation_depth ||= 0

          indent = '  ' * indentation_depth

          error = Error.example(message)

          <<~TEXT
          #{indent}#{error.backtrace[0]}: #{error.message} (#{error.class.name})
          \t#{indent}from #{error.backtrace[1]}
          \t#{indent}from #{error.backtrace[2]}
          TEXT
        end

        module Assertion
          def self.example(caller_location: nil)
            caller_location ||= CallerLocation.example

            assertion_failure = TestBench::Fixture::AssertionFailure.build(caller_location)

            <<~TEXT
            #{assertion_failure.backtrace[0]}: #{assertion_failure.message} (#{assertion_failure.class.name})
            TEXT
          end
        end
      end
    end
  end
end
