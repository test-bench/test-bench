require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Errors" do
      context "Context" do
        context "Verbose" do
          error = Controls::Error.example

          output = Output::Session.new

          output.verbose = true

          Output::PrintError.configure(output, writer: output.writer)

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            context "Some Context" do
              comment "Some text"

              raise error
            end
          end

          test "Prints the error before the end of context marker, indented" do
            control_text = <<~TEXT
            Some Context
              Some text
              #{error.backtrace[0]}: #{error.message} (#{error.class.name})
            \t  from #{error.backtrace[1]}
            \t  from #{error.backtrace[2]}
            Finished context "Some Context" (Result: failure)

            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
