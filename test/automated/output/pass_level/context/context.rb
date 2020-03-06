require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Context" do
      output = Output::Levels::Pass.new

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
        Outer Context
          Pass
            Comment #1
          Comment #2
          Skip (skipped)
          Failure
            Comment #3

        Skipped Outer Context (skipped)

        TEXT
      end
    end
  end
end
