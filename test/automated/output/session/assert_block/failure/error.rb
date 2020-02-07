require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Failure" do
        context "Error Raised By Assert Block" do
          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          caller_location = Controls::CallerLocation.example

          error = Controls::Error.example

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            test "Some test" do
              comment "Text #1"

              assert(caller_location: caller_location) do
                comment "Text #2"

                raise error
              end
            end
          end

          test do
            control_text = <<~TEXT
              Text #1
            Some test
              #{caller_location}: Assertion failed (TestBench::Fixture::AssertionFailure)
                Text #2
                #{error.backtrace[0]}: #{error.message} (#{error.class.name})
            \t    from #{error.backtrace[1]}
            \t    from #{error.backtrace[2]}
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end

