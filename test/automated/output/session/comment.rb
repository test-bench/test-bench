require_relative '../../automated_init'

context "Output" do
  context "Session" do
    context "Comment" do
      output = Output::Session.new

      output.writer.enable_styling!

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        comment "Some comment"

        output.writer.increase_indentation
        comment "Other comment (indented)"
        output.writer.decrease_indentation
      end

      test do
        control_text = <<~TEXT
        Some comment
          Other comment (indented)
        TEXT

        assert(output.writer.written?(control_text))
      end
    end
  end
end
