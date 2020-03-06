require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Context" do
      context "Error" do
        output = Output::Levels::Pass.new

        error = Controls::Error.example

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          context "Example" do
            raise error
          end

          context "Nested Example" do
            context do
              raise error
            end

            comment "Some comment"
          end
        end

        test do
          assert(output.writer.written?(<<~TEXT))
          Example
          #{Controls::Error::Text.example(indentation_depth: 1).chomp}

          Nested Example
          #{Controls::Error::Text.example(indentation_depth: 1).chomp}
            Some comment

          TEXT
        end
      end
    end
  end
end
