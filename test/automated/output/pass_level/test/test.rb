require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Test" do
      output = Output::Levels::Pass.new

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

        test do
          comment "Comment #7"
        end

        comment "Comment #8"

        output.writer.decrease_indentation
      end

      test do
        assert(output.writer.written?(<<~TEXT))
        Comment #1
        Finished test "Pass" (Result: pass)
        Comment #2
        Finished test (Result: pass)
        Skipped test "Skip"
        Skipped test
        Comment #3
        Finished test "Failure" (Result: failure)
        Comment #4
        Finished test (Result: failure)
          Comment #5
          Finished test "Indented pass" (Result: pass)
          Comment #6
          Finished test "Indented failure" (Result: failure)
          Skipped test "Indented skip"
          Comment #7
          Finished test (Result: pass)
          Comment #8
        TEXT
      end
    end
  end
end
