require_relative '../../automated_init'

context "Output" do
  context "Buffer" do
    context "Build" do
      detail = Controls::Output::DetailSetting.example
      verbose = true
      omit_backtrace_pattern = Controls::Pattern.example
      reverse_backtraces = true
      writer = Output::Writer.new
      device = Controls::Device.example
      styling = :on

      buffer_output = Output::Buffer.build(detail: detail, verbose: verbose, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, device: device, styling: styling)

      test "Writer" do
        assert(buffer_output.writer.equal?(writer))
      end

      context "Raw Output Dependency" do
        raw_output = buffer_output.raw_output

        test "Detail setting" do
          assert(raw_output.detail_setting == detail)
        end

        test "Verbose setting" do
          assert(raw_output.verbose == verbose)
        end

        test "Omit backtrace pattern" do
          assert(raw_output.omit_backtrace_pattern == omit_backtrace_pattern)
        end

        test "Reverse backctraces" do
          assert(raw_output.reverse_backtraces == reverse_backtraces)
        end

        test "Writer dependency" do
          assert(raw_output.writer.equal?(writer))
        end
      end
    end
  end
end
