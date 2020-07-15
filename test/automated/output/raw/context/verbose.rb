require_relative '../../../automated_init'

context "Raw Output" do
  context "Context" do
    context "Verbose" do
      output = Output::Raw.new

      output.verbose = true

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
        assert(output.writer.written?(<<~TEXT))
        Outer Context
          Pass
          Finished context "Pass" (Result: pass)
          Failure
          Finished context "Failure" (Result: failure)
          Skip
        Finished context "Outer Context" (Result: failure)

        TEXT
      end
    end
  end
end
