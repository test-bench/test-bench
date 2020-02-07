require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Errors" do
      context "Fixture" do
        context "Verbose Mode" do
          error = Controls::Error.example

          output = Output::Session.new

          output.verbose = true

          Output::PrintError.configure(output, writer: output.writer)

          control_fixture = Controls::Fixture.example(output)

          fixture = nil

          control_fixture.instance_exec do
            fixture = fixture(Controls::Fixture::Example) do
              raise error
            end
          end

          test "Prints the error before the end of fixture marker, indented" do
            control_text = <<~TEXT
            Starting fixture (Fixture: TestBench::Controls::Fixture::Example)
              #{error.backtrace[0]}: #{error.message} (#{error.class.name})
            \t  from #{error.backtrace[1]}
            \t  from #{error.backtrace[2]}
              Finished fixture (Fixture: TestBench::Controls::Fixture::Example, Result: failure)

            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
