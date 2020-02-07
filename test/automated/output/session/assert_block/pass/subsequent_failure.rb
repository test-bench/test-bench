require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Pass" do
        context "Subsequent Failure" do
          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          caller_location = Controls::CallerLocation.example

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            test "Passing assert block" do
              assert do
                comment "Some text"

                assert(true)
              end
            end

            test "Other failure" do
              assert(false, caller_location: caller_location)
            end
          end

          test "Does not print any output from assert block that passed" do
            control_text = <<~TEXT
            Passing assert block
            Other failure
              #{caller_location}: Assertion failed (TestBench::Fixture::AssertionFailure)
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
