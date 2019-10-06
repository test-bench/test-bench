require_relative '../../../automated_init'

context "Output" do
  context "Writer" do
    context "Substitute" do
      context "Set Capture" do
        substitute = Output::Writer::Substitute.build

        substitute.set_capture("Some text")

        context "Stop Capture" do
          return_value = substitute.stop_capture

          test "Returns the text that was captured" do
            assert(return_value == 'Some text')
          end
        end
      end
    end
  end
end
