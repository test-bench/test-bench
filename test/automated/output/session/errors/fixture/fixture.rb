require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Errors" do
      context "Fixture" do
        error = Controls::Error.example

        output = Output::Session.new

        Output::PrintError.configure(output, writer: output.writer)

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          fixture(Controls::Fixture::Example) do
            raise error
          end
        end

        test "Prints the error" do
          control_text = <<~TEXT
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
