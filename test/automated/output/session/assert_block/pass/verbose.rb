require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Pass" do
        context "Verbose Mode" do
          output = Output::Session.new

          output.writer.enable_styling!

          output.verbose = true

          caller_location = Controls::CallerLocation.example

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            assert(caller_location: caller_location) do
              comment "Some text"

              assert(true)
            end
          end

          test do
            control_text = <<~TEXT
            \e[34mEntering assert block (Caller Location: #{caller_location}, Depth: 1)\e[39m
              Some text
            \e[36mExited assert block (Caller Location: #{caller_location}, Depth: 1, Result: pass)\e[39m
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
