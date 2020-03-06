require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Test" do
      context "Styling" do
        output = Output::Levels::Pass.new

        output.writer.enable_styling!

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          test "Pass" do
            comment "Comment #1"
          end

          test do
            comment "Comment #2"
          end

          test "Failure" do
            comment "Comment #3"

            test_session.fail!
          end

          test do
            comment "Comment #4"

            test_session.fail!
          end

          test "Skip"

          test
        end

        test do
          assert(output.writer.written?(<<~TEXT))
          Comment #1
          \e[32mPass\e[39m
          Comment #2
          Comment #3
          \e[1;31mFailure\e[39;22m
          Comment #4
          \e[1;31mTest\e[39;22m
          \e[33mSkip\e[39m
          \e[33mTest\e[39m
          TEXT
        end
      end
    end
  end
end
