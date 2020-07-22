require_relative '../../../automated_init'

context "Raw Output" do
  context "Context" do
    context "Error" do
      output = Output::Raw.new

      error = Controls::Error.example

      control_fixture = Controls::Fixture.example(output, error_policy: :rescue)

      control_fixture.instance_exec do
        context "Some Context" do
          raise error
        end
      end

      test do
        assert(output.writer.written?(<<TEXT))
Some Context
#{Controls::Error::Text.example(indentation_depth: 1).chomp}

TEXT
      end
    end
  end
end
