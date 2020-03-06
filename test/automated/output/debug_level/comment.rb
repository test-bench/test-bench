require_relative '../../automated_init'

context "Output" do
  context "Debug Level" do
    context "Comment" do
      output = Output::Levels::Debug.new

      output.writer.enable_styling!

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        comment "Some comment"

        output.writer.increase_indentation
        comment "Other comment (indented)"
        output.writer.decrease_indentation
      end

      test do
        assert(output.writer.written?(<<~TEXT))
        Some comment
          Other comment (indented)
        TEXT
      end
    end
  end
end
