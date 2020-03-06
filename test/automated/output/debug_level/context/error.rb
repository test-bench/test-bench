require_relative '../../../automated_init'

context "Output" do
  context "Debug Level" do
    context "Context" do
      context "Error" do
        output = Output::Levels::Debug.new

        error = Controls::Error.example

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          context "Error Example" do
            raise error
          end
        end

        test do
          assert(output.writer.written?(<<~TEXT))
          Error Example
          #{Controls::Error::Text.example(indentation_depth: 1).chomp}
          Finished context "Error Example" (Result: failure)

          TEXT
        end
      end
    end
  end
end
