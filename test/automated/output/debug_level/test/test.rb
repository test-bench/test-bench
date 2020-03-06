require_relative '../../../automated_init'

context "Output" do
  context "Debug Level" do
    context "Test" do
      output = Output::Levels::Debug.new

      output.writer.enable_styling!

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        test "Pass" do
          comment "Comment #1"
        end

        test do
          comment "Comment #2"
        end

        test "Skip"

        test

        test "Failure" do
          comment "Comment #3"

          test_session.fail!
        end

        test do
          comment "Comment #4"

          test_session.fail!
        end

        output.writer.increase_indentation

        test "Indented pass" do
          comment "Comment #5"
        end

        test "Indented failure" do
          test_session.fail!

          comment "Comment #6"
        end

        test "Indented skip"

        output.writer.decrease_indentation
      end

      test do
        assert(output.writer.written?(<<~TEXT))
          \e[36mStarting test "Pass"\e[39m
            Comment #1
          \e[32mFinished test \e[1m"Pass"\e[22m (Result: pass)\e[39m
          \e[36mStarting test\e[39m
            Comment #2
          \e[32mFinished test (Result: pass)\e[39m
          \e[33mSkipped test \e[1m"Skip"\e[22;39m
          \e[33mSkipped test\e[39m
          \e[36mStarting test "Failure"\e[39m
            Comment #3
          \e[31mFinished test \e[1m"Failure"\e[22m (Result: failure)\e[39m
          \e[36mStarting test\e[39m
            Comment #4
          \e[31mFinished test (Result: failure)\e[39m
            \e[36mStarting test "Indented pass"\e[39m
              Comment #5
            \e[32mFinished test \e[1m"Indented pass"\e[22m (Result: pass)\e[39m
            \e[36mStarting test "Indented failure"\e[39m
              Comment #6
            \e[31mFinished test \e[1m"Indented failure"\e[22m (Result: failure)\e[39m
            \e[33mSkipped test \e[1m"Indented skip"\e[22;39m
        TEXT
      end
    end
  end
end
