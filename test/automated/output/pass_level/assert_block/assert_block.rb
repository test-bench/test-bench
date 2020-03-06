require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Assert Block" do
      output = Output::Levels::Pass.new

      caller_location_1 = Controls::CallerLocation.example
      caller_location_2 = Controls::CallerLocation::Alternate.example

      error = Controls::Error.example

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        test "Pass" do
          comment "Comment #1"

          assert do
            comment "Comment #2"

            assert(true)
          end
        end

        test "Failure" do
          assert(caller_location: caller_location_1) do
            comment "Comment #3"

            assert(false, caller_location: caller_location_2)
          end
        end

        test "Error" do
          assert(caller_location: caller_location_1) do
            raise error
          end
        end

        test "Subsequent test" do
          session.fail!
        end

        context "Some Context" do
          test "Pass" do
            #
          end

          assert(caller_location: caller_location_1) do
            comment "Comment #4"

            session.fail!
          end
        end
      end

      test do
        assert(output.writer.written?(<<~TEXT))
        Comment #1
        Pass
        Failure
          #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
            Comment #3
            #{caller_location_2}: Assertion failed (TestBench::Fixture::AssertionFailure)
        Error
          #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
        #{Controls::Error::Text.example(indentation_depth: 2).chomp}
        Subsequent test
        Some Context
          Pass
          #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
            Comment #4

        TEXT
      end
    end
  end
end
