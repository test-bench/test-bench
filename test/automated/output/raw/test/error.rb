require_relative '../../../automated_init'

context "Raw Output" do
  context "Test" do
    context "Error" do
      output = Output::Raw.new

      error = Controls::Error.example

      control_fixture = Controls::Fixture.example(output, error_policy: :rescue)

      control_fixture.instance_exec do
        test "Some test" do
          comment "Indentation Mark"

          raise error
        end
      end

      test do
        assert(output.writer.written?(<<TEXT))
Starting test "Some test"
  Indentation Mark
#{Controls::Error::Text.example(indentation_depth: 1).chomp}
Some test (failed)
TEXT
      end
    end
  end
end
