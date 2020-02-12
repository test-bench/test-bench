require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Failure" do
        context "No Assertion Performed By Assert Block" do
          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          caller_location = Controls::CallerLocation.example

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            test "Some test" do
              comment "Text #1"

              assert(caller_location: caller_location) do
                comment "Text #2"
              end
            end
          end

          test do
            control_text = <<~TEXT
              Text #1
            Some test
              #{caller_location}: Assertion failed (TestBench::Fixture::AssertionFailure)
                Text #2
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
