require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Errors" do
      context "Context" do
        context "Nesting" do
          error = Controls::Error.example

          output = Output::Session.new

          Output::PrintError.configure(output, writer: output.writer)

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            context "Outer Context" do
              context "Inner Context" do
                raise error
              end
            end
          end

          test "Prints the error only once" do
            control_text = <<~TEXT
            Outer Context
              Inner Context
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
