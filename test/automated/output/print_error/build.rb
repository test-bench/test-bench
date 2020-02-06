require_relative '../../automated_init'

context "Output" do
  context "Print Error" do
    context "Build" do
      context do
        omit_backtrace_pattern = Controls::Pattern.example
        reverse_backtraces = true

        print_error = Output::PrintError.build(
          omit_backtrace_pattern: omit_backtrace_pattern,
          reverse_backtraces: reverse_backtraces
        )

        context "Omit Backtrace Pattern" do
          test do
            assert(print_error.omit_backtrace_pattern == omit_backtrace_pattern)
          end
        end

        context "Reverse Backtraces" do
          test do
            assert(print_error.reverse_backtraces == reverse_backtraces)
          end
        end
      end

      context "Optional Writer Argument Given" do
        writer = Output::Writer.new

        print_error = Output::PrintError.build(writer: writer)

        test "Given writer is assigned to print_error" do
          assert(print_error.writer.equal?(writer))
        end
      end

      context "Styling And Device Arguments Given" do
        styling = Controls::Output::Styling.example
        device = Controls::Device.example

        print_error = Output::PrintError.build(styling: styling, device: device)

        writer = print_error.writer or fail

        test "A writer is configured" do
          assert(writer.instance_of?(Output::Writer))
        end

        test "Writer is configured to write to given device" do
          assert(writer.device.equal?(device))
        end

        test "Styling is set on writer" do
          assert(writer.styling == styling)
        end
      end
    end
  end
end
