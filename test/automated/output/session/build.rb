require_relative '../../automated_init'

context "Output" do
  context "Session" do
    context "Build" do
      context "Verbose Argument Given" do
        output = Output::Session.build(verbose: true)

        test "Attribute is set on session" do
          assert(output.verbose == true)
        end
      end

      context "Optional Writer Argument Given" do
        writer = Output::Writer.new

        output = Output::Session.build(writer: writer)

        test "Given writer is assigned to output" do
          assert(output.writer.equal?(writer))
        end

        test "Given writer is assigned to print error dependency" do
          assert(output.print_error.writer.equal?(writer))
        end
      end

      context "Styling And Device Arguments Given" do
        styling = Controls::Output::Styling.example
        device = Controls::Device.example

        output = Output::Session.build(styling: styling, device: device)

        writer = output.writer or fail

        test "A writer is configured" do
          assert(writer.instance_of?(Output::Writer))
        end

        test "Writer is configured to write to given device" do
          assert(writer.device.equal?(device))
        end

        test "Styling is set on writer" do
          assert(writer.styling == styling)
        end

        test "Configured writer is assigned to print error dependency" do
          assert(output.print_error.writer.equal?(writer))
        end
      end

      context "Omit Backtrace Pattern Argument Given" do
        pattern = Controls::Pattern.example

        output = Output::Session.build(omit_backtrace_pattern: pattern)

        test "Attribute is set on print error dependency" do
          assert(output.print_error.omit_backtrace_pattern == pattern)
        end
      end

      context "Reverse Backtraces Argument Given" do
        output = Output::Session.build(reverse_backtraces: true)

        test "Attribute is set on print error dependency" do
          assert(output.print_error.reverse_backtraces == true)
        end
      end
    end
  end
end
