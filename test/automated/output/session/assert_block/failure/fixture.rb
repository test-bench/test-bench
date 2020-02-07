require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Failure" do
        context "Fixture" do
          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          caller_location_1 = Controls::CallerLocation.example
          caller_location_2 = Controls::CallerLocation::Alternate.example

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            fixture(Controls::Fixture::Example) do
              comment "Text #1"

              assert(caller_location: caller_location_1) do
                comment "Text #2"

                assert(false, caller_location: caller_location_2)
              end
            end
          end

          test do
            control_text = <<~TEXT
            Text #1
            #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
              Text #2
              #{caller_location_2}: Assertion failed (TestBench::Fixture::AssertionFailure)
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
