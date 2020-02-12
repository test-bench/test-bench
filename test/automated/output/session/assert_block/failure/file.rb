require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Failure" do
        context "File" do
          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          caller_location = Controls::CallerLocation::Alternate.example
          assertion_failure = Fixture::AssertionFailure.build(caller_location)

          error = Controls::Error.example

          path = Controls::TestFile.filename

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            output.enter_file(path)

            test_session.evaluate(->{
              comment "Text #1"

              assert(caller_location: caller_location) do
                comment "Text #2"

                raise error
              end
            })

            output.exit_file(path, false)
          end

          test do
            control_text = <<~TEXT
            Running #{path}
            Text #1
            #{caller_location}: Assertion failed (TestBench::Fixture::AssertionFailure)
              Text #2
              #{error.backtrace[0]}: #{error.message} (#{error.class.name})
            \t  from #{error.backtrace[1]}
            \t  from #{error.backtrace[2]}

            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
