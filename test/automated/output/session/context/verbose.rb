require_relative '../../../automated_init'

context "Output" do
  context "Session" do
    context "Context" do
      context "Verbose Mode" do
        output = Output::Session.new

        output.verbose = true

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
            \e[2;3;32mFinished context "Pass" (Result: pass)\e[39;23;22m
            \e[33mSkip\e[39m
            \e[32mFailure\e[39m
              Text #2
            \e[2;3;31mFinished context "Failure" (Result: failure)\e[39;23;22m
          \e[2;3;31mFinished context "Outer Context" (Result: failure)\e[39;23;22m

          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
