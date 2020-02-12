require_relative '../../../automated_init'

context "Output" do
  context "Writer" do
    context "Substitute" do
      context "Capturing Predicate" do
        context "Capture Started" do
          substitute = Output::Writer::Substitute.build

          substitute.start_capture

          test do
            assert(substitute.capturing? == true)
          end
        end

        context "Capture Not Started" do
          substitute = Output::Writer::Substitute.build

          test do
            assert(substitute.capturing? == false)
          end
        end
      end
    end
  end
end
