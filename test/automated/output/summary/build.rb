require_relative '../../automated_init'

context "Output" do
  context "Summary" do
    context "Build" do
      writer = Output::Writer.new
      device = Controls::Device.example
      styling = :on

      summary = Output::Summary.build(writer: writer, device: device, styling: styling)

      test "Writer dependency" do
        assert(summary.writer.equal?(writer))
      end

      test "Timer dependency" do
        assert(summary.timer.instance_of?(Output::Timer))
      end
    end
  end
end
