require_relative '../../../automated_init'

context "Raw Output" do
  context "Context" do
    context "No Title" do
      output = Output::Raw.new

      output.verbose = true

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        context do
          context "Context #1" do
            context do
              context "Context #2" do
                #
              end

              context
            end
          end
        end
      end

      test do
        assert(output.writer.written?(<<~TEXT))
        Context #1
          Context #2
          Finished context "Context #2" (Result: pass)
        Finished context "Context #1" (Result: pass)

        TEXT
      end
    end
  end
end
