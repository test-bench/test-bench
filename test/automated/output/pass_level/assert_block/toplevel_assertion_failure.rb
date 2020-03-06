require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Assert Block" do
      context "Toplevel Assertion Failure" do
        output = Output::Levels::Pass.new

        caller_location = Controls::CallerLocation.example

        file = Controls::TestFile.filename

        result = Controls::Result::Failure.example

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          output.enter_file(file)

          comment "Comment #1"

          session.evaluate(->{
            assert(caller_location: caller_location) do
              comment "Comment #2"
            end
          })

          output.exit_file(file, result)
        end

        test do
          assert(output.writer.written?(<<~TEXT))
          Running #{file}
          Comment #1
          #{caller_location}: Assertion failed (TestBench::Fixture::AssertionFailure)
            Comment #2
          TEXT
        end
      end
    end
  end
end
