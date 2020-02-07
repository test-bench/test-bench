require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Errors" do
      context "Context" do
        context "No Title" do
          error = Controls::Error.example

          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            context do
              comment "Some text"

              raise error
            end
          end

          test "Prints the error, unindented" do
            control_text = <<~TEXT
            Some text
            #{error.backtrace[0]}: #{error.message} (#{error.class.name})
            \tfrom #{error.backtrace[1]}
            \tfrom #{error.backtrace[2]}
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
