require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Pass" do
        context "Nesting" do
          output = Output::Session.new

          output.verbose = true

          caller_location_1 = Controls::CallerLocation.example
          caller_location_2 = Controls::CallerLocation::Alternate.example

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            assert(caller_location: caller_location_1) do
              comment "Text #1"

              assert(caller_location: caller_location_2) do
                comment "Text #2"

                assert(true)
              end
            end
          end

          test do
            control_text = <<~TEXT
            Entering assert block (Caller Location: #{caller_location_1}, Depth: 1)
              Text #1
              Entering assert block (Caller Location: #{caller_location_2}, Depth: 2)
                Text #2
              Exited assert block (Caller Location: #{caller_location_2}, Depth: 2, Result: pass)
            Exited assert block (Caller Location: #{caller_location_1}, Depth: 1, Result: pass)
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
