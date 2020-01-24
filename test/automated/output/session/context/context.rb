require_relative '../../../automated_init'

context "Output" do
  context "Session" do
    context "Context" do
      output = Output::Session.new

      output.writer.enable_styling!

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        context "Outer Context" do
          context "Pass" do
            comment "Text #1"
          end

          context "Skip"

          context "Failure" do
            comment "Text #2"

            test_session.fail!
          end
        end
      end

      test do
        control_text = <<~TEXT
        \e[32mOuter Context\e[39m
          \e[32mPass\e[39m
            Text #1
          \e[33mSkip\e[39m
          \e[32mFailure\e[39m
            Text #2

        TEXT

        assert(output.writer.written?(control_text))
      end
    end
  end
end
