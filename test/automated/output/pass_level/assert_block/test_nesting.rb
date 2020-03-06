require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Assert Block" do
      context "Test Nesting" do
        output = Output::Levels::Pass.new

        caller_location_1 = Controls::CallerLocation.example
        caller_location_2 = Controls::CallerLocation::Alternate.example

        error = Controls::Error.example

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          test "Outer" do
            test "Inner" do
              assert(caller_location: caller_location_1) do
                comment "Comment #1"
                session.fail!
              end
            end

            assert(caller_location: caller_location_2) do
              comment "Comment #2"
              session.fail!
            end
          end
        end

        test do
          assert(output.writer.written?(<<~TEXT))
          Finished test "Inner" (Result: failure)
            #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
              Comment #1
          Finished test "Outer" (Result: failure)
            #{caller_location_2}: Assertion failed (TestBench::Fixture::AssertionFailure)
              Comment #2
          TEXT
        end
      end
    end
  end
end
