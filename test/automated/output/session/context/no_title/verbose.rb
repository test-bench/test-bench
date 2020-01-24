require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Context" do
      context "No Title" do
        context "Verbose Mode" do
          output = Output::Session.new

          output.verbose = true

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            context "Some Context" do
              context do
                comment "Text #1"
              end
            end

            context do
              comment "Text #2"
            end

            comment "Text #3"

            context do
              comment "Text #4"

              test_session.fail!
            end

            context
          end

          test do
            control_text = <<~TEXT
            Some Context
              Text #1
            Finished context "Some Context" (Result: pass)

            Text #2
            Text #3
            Text #4
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
