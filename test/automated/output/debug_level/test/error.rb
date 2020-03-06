require_relative '../../../automated_init'

context "Output" do
  context "Debug Level" do
    context "Test" do
      context "Error" do
        output = Output::Levels::Debug.new

        error = Controls::Error.example

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          test "Error example" do
            raise error
          end
        end

        test do
          assert(output.writer.written?(<<~TEXT))
          Starting test "Error example"
          #{Controls::Error::Text.example(indentation_depth: 1).chomp}
          Finished test "Error example" (Result: failure)
          TEXT
        end
      end
    end
  end
end
