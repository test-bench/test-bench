require_relative '../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Build" do
      context do
        output = Output::Summary::Run.build

        test "Timer dependency is configured and assigned to output" do
          assert(output.timer.instance_of?(Output::Timer))
        end
      end

      context "Optional Writer Argument Given" do
        writer = Output::Writer.new

        output = Output::Summary::Run.build(writer: writer)

        test "Given writer is assigned to output" do
          assert(output.writer.equal?(writer))
        end
      end

      context "Styling And Device Arguments Given" do
        styling = Controls::Output::Styling.example
        device = Controls::Device.example

        output = Output::Summary::Run.build(styling: styling, device: device)

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
      end
    end
  end
end
