require_relative '../../automated_init'

context "Output" do
  context "Failure Level" do
    context "Build" do
      omit_backtrace_pattern = Controls::Pattern.example
      reverse_backtraces = true
      writer = Output::Writer.new
      device = Controls::Device.example
      styling = :on

      output = Output::Levels::Failure.build(omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, writer: writer, device: device, styling: styling)

      test "Omit backtrace pattern" do
        assert(output.omit_backtrace_pattern == omit_backtrace_pattern)
      end

      test "Reverse backctraces" do
        assert(output.reverse_backtraces == reverse_backtraces)
      end

      test "Writer dependency" do
        assert(output.writer.equal?(writer))
      end
    end
  end
end
