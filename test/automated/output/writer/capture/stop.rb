require_relative '../../../automated_init'

context "Output" do
  context "Writer" do
    context "Capture" do
      context "Stop Capture" do
        context "Writer Is Capturing" do
          writer = Output::Writer.new

          string = String.new
          writer.start_capture(string)

          assert(writer.capturing?)

          writer.text("Some text")

          previous_device = writer.previous_device or fail

          return_value = writer.stop_capture

          test "Device is returned to previous device" do
            assert(writer.device.equal?(previous_device))
          end

          test "Previous device is reset" do
            assert(writer.previous_device.nil?)
          end

          test "String is returned" do
            assert(return_value == "Some text")
          end

          test "Writer is no longer capturing" do
            refute(writer.capturing?)
          end
        end

        context "Not Yet Capturing" do
          writer = Output::Writer.new

          refute(writer.capturing?)

          test "Raises an error" do
            assert_raises(Output::Writer::Error) do
              writer.stop_capture
            end
          end
        end
      end
    end
  end
end
