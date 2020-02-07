require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Failure" do
        context "Nested Structure" do
          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          caller_location_1 = Controls::CallerLocation.example
          caller_location_2 = Controls::CallerLocation::Alternate.example

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            context "Some Context" do
              test "Some test" do
                assert(caller_location: caller_location_1) do
                  comment "Text #1"

                  context do
                    comment "Text #2"

                    assert(false, caller_location: caller_location_2)
                  end
                end
              end
            end
          end

          test do
            control_text = <<~TEXT
            Some Context
              Some test
                #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
                  Text #1
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
