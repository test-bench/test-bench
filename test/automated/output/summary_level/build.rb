require_relative '../../automated_init'

context "Output" do
  context "Summary Level" do
    context "Build" do
      writer = Output::Writer.new
      device = Controls::Device.example
      styling = :on

      output = Output::Levels::Summary.build(writer: writer, device: device, styling: styling)

      test do
        assert(output.writer.equal?(writer))
      end

      test "Timer dependency is configured" do
        assert(output.timer.instance_of?(Output::Timer))
      end
    end
  end
end
