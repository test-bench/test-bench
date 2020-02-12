require_relative '../../automated_init'

context "Output" do
  context "Build" do
    omit_backtrace_pattern = Controls::Pattern.example
    reverse_backtraces = true
    writer = Output::Writer.new
    styling = Controls::Output::Styling.example
    device = Controls::Device.example

    [
      :none,
      :summary,
      :failure,
      :pass,
      :debug
    ].each do |level|
      context "Level: #{level.inspect}" do
        output = Output.build(
          level: level,
          omit_backtrace_pattern: omit_backtrace_pattern,
          reverse_backtraces: reverse_backtraces,
          writer: writer,
          styling: styling,
          device: device
        )

        test do
          assert(output.level?(level))
        end
      end
    end
  end
end
