require_relative '../automated_init'

context "Output" do
  context "Build" do
    log_level = Controls::Output::LogLevel.example
    detail = Controls::Output::DetailSetting.example
    verbose = true
    omit_backtrace_pattern = Controls::Pattern.example
    reverse_backtraces = true
    writer = Output::Writer.new
    device = Controls::Device.example
    styling = :on

    output = Output.build(log_level: log_level, detail: detail, verbose: verbose, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, device: device, styling: styling)

    test "Dispatches to multiple outputs" do
      assert(output.instance_of?(Fixture::Output::Multiple))
    end

    context "Outputs" do
      context "Buffer Output" do
        buffer_output = output.outputs.any? do |output|
          output.instance_of?(Output::Buffer)
        end

        test do
          assert(buffer_output)
        end
      end

      context "Summary" do
        summary = output.outputs.any? do |output|
          output.instance_of?(Output::Summary)
        end

        test do
          assert(summary)
        end
      end

      context "Log Output" do
        log_output = output.outputs.any? do |output|
          output.instance_of?(Fixture::Output::Log)
        end

        test do
          assert(log_output)
        end
      end
    end
  end
end
