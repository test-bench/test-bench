require_relative '../../../automated_init'

context "Output" do
  context "Debug Level" do
    context "Context" do
      output = Output::Levels::Debug.new

      output.writer.enable_styling!

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        context "Outer Context" do
          context "Pass" do
            comment "Comment #1"
          end

          context do
            comment "Comment #2"
          end

          context "Skip"

          context

          context "Failure" do
            comment "Comment #3"

            test_session.fail!
          end
        end

        context "Skipped Outer Context"
      end

      test do
        assert(output.writer.written?(<<~TEXT))
        \e[32mOuter Context\e[39m
          \e[32mPass\e[39m
            Comment #1
          \e[2;3;32mFinished context "Pass" (Result: pass)\e[39;23;22m
          Comment #2
          \e[33mSkip\e[39m
          \e[32mFailure\e[39m
            Comment #3
          \e[2;3;31mFinished context "Failure" (Result: failure)\e[39;23;22m
        \e[2;3;31mFinished context "Outer Context" (Result: failure)\e[39;23;22m

        \e[33mSkipped Outer Context\e[39m

        TEXT
      end
    end
  end
end
