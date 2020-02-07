require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Test" do
      context "No Title" do
        output = Output::Session.new

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
              Text #1

          Skip
            Text #2
            Test

          Failure
              Text #3
            Test

          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
