require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Failure" do
        context "Abort Error Policy" do
          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          caller_location_1 = Controls::CallerLocation.example
          caller_location_2 = Controls::CallerLocation::Alternate.example

          control_fixture = Controls::Fixture.example(output, error_policy: :abort)

          #Fixture::Output::Log.configure(control_fixture.test_session)

          control_fixture.instance_exec do
            test "Some test" do
              assert(caller_location: caller_location_1) do
                comment "Some text"

                assert(false, caller_location: caller_location_2)
              end
            end

          rescue SystemExit
          end

          test do
            control_text = <<~TEXT
            Some test
              #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
                Some text
                #{caller_location_2}: Assertion failed (TestBench::Fixture::AssertionFailure)
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
