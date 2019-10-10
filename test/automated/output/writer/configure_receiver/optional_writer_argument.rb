require_relative '../../../automated_init'

context "Output" do
  context "Writer" do
    context "Configure Receiver" do
      context "Optional Writer Argument" do
        context "Given" do
          writer = Output::Writer.new

          receiver = OpenStruct.new

          Output::Writer.configure(receiver, writer: writer)

          writer = receiver.writer

          test "Assigns given writer to the receiver's output" do
            assert(writer.equal?(writer))
          end
        end

        context "Omitted" do
          device = Controls::Device.example
          styling = :on

          receiver = OpenStruct.new

          Output::Writer.configure(receiver, device: device, styling: styling)

          writer = receiver.writer

          test "Configures the receiver's writer" do
            assert(writer.instance_of?(Output::Writer))
          end

          test "Writer is configured with the given device" do
            assert(writer.device.equal?(device))
          end

          test "Styling is set on the writer" do
            assert(writer.styling == styling)
          end
        end
      end
    end
  end
end
