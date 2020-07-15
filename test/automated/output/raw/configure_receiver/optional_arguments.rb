require_relative '../../../automated_init'

context "Raw Output" do
  context "Configure Receiver" do
    context "Optional Arguments" do
      detail = Controls::Output::DetailSetting.example
      verbose = true
      omit_backtrace_pattern = Controls::Pattern.example
      reverse_backtraces = true
      writer = Output::Writer.new
      device = Controls::Device.example
      styling = :on

      receiver = OpenStruct.new

      Output::Raw.configure(receiver, detail: detail, verbose: verbose, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, device: device, styling: styling)

      output = receiver.raw_output

      test "Detail" do
        assert(output.detail_setting == detail)
      end

      test "Verbose" do
        assert(output.verbose == verbose)
      end

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
