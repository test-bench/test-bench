require_relative '../../../automated_init'

context "Raw Output" do
  context "Test" do
    context "Styling" do
      output = Output::Raw.new

      output.verbose = true

      output.writer.enable_styling!

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        test "Pass" do
          comment "Indentation Mark"

          assert(true)
        end

        test "Failure" do
          comment "Indentation Mark"

          test_session.fail!
        end

        test "Skip"
      end

      test do
        assert(output.writer.written?(<<TEXT))
\e[2;3;34mStarting test "Pass"\e[39;23;22m
  Indentation Mark
\e[32mPass\e[39m
\e[2;3;34mStarting test "Failure"\e[39;23;22m
  Indentation Mark
\e[31mFailure\e[39m
\e[33mSkip\e[39m
TEXT
      end
    end
  end
end
