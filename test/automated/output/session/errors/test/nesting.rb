require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Errors" do
      context "Test" do
        context "Nesting" do
          error = Controls::Error.example

          output = Output::Session.new

          output.verbose = true

          Output::PrintError.configure(output, writer: output.writer)

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            test "Outer test" do
              test "Inner test" do
                raise error
              end
            end
          end

          test "Prints the error only once" do
            control_text = <<~TEXT
            Starting test "Outer test"
              Starting test "Inner test"
              Inner test
                #{error.backtrace[0]}: #{error.message} (#{error.class.name})
            \t    from #{error.backtrace[1]}
            \t    from #{error.backtrace[2]}
            Outer test
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
