require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Test" do
      context "No Title" do
        context "Verbose" do
          output = Output::Session.new

          output.verbose = true

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            context "Pass" do
              test do
                comment "Text #1"
              end
            end

            context "Skip" do
              comment "Text #2"

              test
            end

            context "Failure" do
              test do
                comment "Text #3"

                test_session.fail!
              end
            end
          end

          test do
            control_text = <<~TEXT
            Pass
              Starting test (no title)
                Text #1
              Test
            Finished context "Pass" (Result: pass)

            Skip
              Text #2
              Test
            Finished context "Skip" (Result: pass)

            Failure
              Starting test (no title)
                Text #3
              Test
            Finished context "Failure" (Result: failure)

            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
