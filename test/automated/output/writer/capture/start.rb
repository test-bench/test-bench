require_relative '../../../automated_init'

context "Output" do
  context "Writer" do
    context "Capture" do
      context "Start Capture" do
        string = String.new

        context "Not Already Capturing" do
          writer = Output::Writer.new

          refute(writer.capturing?)

          previous_device = writer.device or fail

          writer.start_capture(string)

          test "Device is changed to a string IO" do
            assert(writer.device.instance_of?(StringIO))
          end

          test "Previous device is saved" do
            assert(writer.previous_device.equal?(previous_device))
          end

          test "Device is configured to write to given string" do
            assert(writer.device.string.equal?(string))
          end

          test "Writer is capturing" do
            assert(writer.capturing?)
          end
        end

        context "Already Capturing" do
          writer = Output::Writer.new

          writer.start_capture(string)

          assert(writer.capturing?)

          test "Raises an error" do
            assert_raises(Output::Writer::Error) do
              writer.start_capture(string)
            end
          end
        end
      end
    end
  end
end
