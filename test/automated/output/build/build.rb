require_relative '../../automated_init'

context "Output" do
  context "Build" do
    omit_backtrace_pattern = Controls::Pattern.example
    reverse_backtraces = true
    writer = Output::Writer.new
    styling = Controls::Output::Styling.example
    device = Controls::Device.example

    context "Level: None" do
      output = Output.build(level: :none)

      test do
        assert(output.instance_of?(Output::Levels::None))
      end
    end

    context "Level: Summary" do
      output = Output.build(level: :summary, writer: writer, styling: styling, device: device)

      test do
        assert(output.instance_of?(Output::Levels::Summary))
      end
    end

    context "Level: Failure" do
      output = Output.build(level: :failure, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, styling: styling, device: device)

      test do
        assert(output.instance_of?(Output::Levels::Failure))
      end
    end

    context "Level: Debug" do
      output = Output.build(level: :debug, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, styling: styling, device: device)

      test do
        assert(output.instance_of?(Output::Levels::Debug))
      end
    end

    context "Level: Pass" do
      output = Output.build(level: :pass, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, styling: styling, device: device)

      test do
        assert(output.instance_of?(Output::Levels::Pass))
      end
    end
  end
end
