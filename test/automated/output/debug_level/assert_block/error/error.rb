require_relative '../../../../automated_init'

context "Output" do
  context "Debug Level" do
    context "Assert Block" do
      context "Error" do
        output = Output::Levels::Debug.new

        caller_location = Controls::CallerLocation.example

        error = Controls::Error.example

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          context "Some Context" do
            test "Error" do
              assert(caller_location: caller_location) do
                raise error
              end
            end
          end
        end

        test do
          assert(output.writer.written?(<<~TEXT))
          Some Context
            Starting test "Error"
              Entered assert block (Caller Location: #{caller_location})
              Exited assert block (Caller Location: #{caller_location}, Result: failure)
          #{Controls::Error::Text.example(indentation_depth: 2).chomp}
            Finished test "Error" (Result: failure)
          Finished context "Some Context" (Result: failure)

          TEXT
        end
      end
    end
  end
end
