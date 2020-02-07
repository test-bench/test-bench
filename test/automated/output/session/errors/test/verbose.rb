require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Errors" do
      context "Test" do
        context "Verbose Mode" do
          error = Controls::Error.example

          output = Output::Session.new

          output.verbose = true

          Output::PrintError.configure(output, writer: output.writer)

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            test "Some test" do
              raise error
            end
          end

          test "Prints the error after the test title, indented" do
            control_text = <<~TEXT
            Starting test "Some test"
            Some test
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
