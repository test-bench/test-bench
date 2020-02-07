require_relative '../../../automated_init'

context "Output" do
  context "Session" do
    context "Context" do
      context "Skipped Outer Context" do
        output = Output::Session.new

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          context "Outer Context"
        end

        test do
          control_text = <<~TEXT
          Outer Context

          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
