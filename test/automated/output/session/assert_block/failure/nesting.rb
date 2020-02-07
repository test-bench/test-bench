require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Failure" do
        context "Nesting Of Assert Blocks" do
          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          caller_location_1 = Controls::CallerLocation.example
          caller_location_2 = Controls::CallerLocation::Alternate.example

          error = Controls::Error.example

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            test "Some test" do
              comment "Text #1"

              assert(caller_location: caller_location_1) do
                comment "Text #2"

                assert(caller_location: caller_location_2) do
                  comment "Text #3"

                  raise error
                end
              end
            end
          end

          test do
            control_text = <<~TEXT
              Text #1
            Some test
              #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
                Text #2
                Text #3
                #{error.backtrace[0]}: #{error.message} (#{error.class.name})
            \t    from #{error.backtrace[1]}
            \t    from #{error.backtrace[2]}
                #{caller_location_2}: Assertion failed (TestBench::Fixture::AssertionFailure)
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
