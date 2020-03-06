require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Assert Block" do
      context "Fixture" do
        output = Output::Levels::Pass.new

        caller_location = Controls::CallerLocation.example

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          test "Some test" do
            assert(true)
          end

          fixture(Controls::Fixture.example_class) do
            comment "Comment #1"

            assert(caller_location: caller_location) do
              comment "Comment #2"

              session.fail!
            end
          end
        end

        test do
          assert(output.writer.written?(<<~TEXT))
          Finished test "Some test" (Result: pass)
          Comment #1
          #{caller_location}: Assertion failed (TestBench::Fixture::AssertionFailure)
            Comment #2
          TEXT
        end
      end
    end
  end
end
