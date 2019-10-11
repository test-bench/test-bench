require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Styling Selection" do
      context "Detect" do
        styling = :detect

        context "Interactive Device" do
          device = Controls::Device::Interactive.example

          writer = Output::Writer.build(device, styling: styling)

          test "Enabled" do
            assert(writer.styling? == true)
          end
        end

        context "Non-Interactive Device" do
          device = Controls::Device::Interactive::Non.example

          writer = Output::Writer.build(device, styling: styling)

          test "Disabled" do
            assert(writer.styling? == false)
          end
        end
      end

      context "On" do
        styling = :on

        device = Controls::Device::Interactive::Non.example

        writer = Output::Writer.build(device, styling: styling)

        test "Enabled" do
          assert(writer.styling? == true)
        end
      end

      context "Setting: Disabled" do
        styling = :off

        device = Controls::Device::Interactive.example

        writer = Output::Writer.build(device, styling: styling)

        test "Disabled" do
          assert(writer.styling? == false)
        end
      end

      context "Setting: Unknown" do
        styling = :unknown

        test "Raises an error" do
          assert_raises(Output::Writer::Error) do
            Output::Writer.build(styling: styling)
          end
        end
      end
    end
  end
end
