require_relative '../../../automated_init'

context "Raw Output" do
  context "Context" do
    context "Styling" do
      output = Output::Raw.new

      output.verbose = true

      output.writer.enable_styling!

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        context "Outer Context" do
          context "Pass" do
            #
          end

          context "Failure" do
            test_session.fail!
          end

          context "Skip"
        end
      end

      test do
        assert(output.writer.written?(<<TEXT))
\e[32mOuter Context\e[39m
  \e[32mPass\e[39m
  \e[2;3;32mFinished context "Pass" (Result: pass)\e[39;23;22m
  \e[32mFailure\e[39m
  \e[2;3;31mFinished context "Failure" (Result: failure)\e[39;23;22m
  \e[33mSkip\e[39m
\e[2;3;31mFinished context "Outer Context" (Result: failure)\e[39;23;22m

TEXT
      end
    end
  end
end
