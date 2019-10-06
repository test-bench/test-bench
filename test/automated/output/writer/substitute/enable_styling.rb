require_relative '../../../automated_init'

context "Output" do
  context "Writer" do
    context "Substitute" do
      context "Enable Styling" do
        substitute = Output::Writer::Substitute.build
        refute(substitute.styling?)

        substitute.enable_styling!

        test "Styling is enabled" do
          assert(substitute.styling?)
        end
      end
    end
  end
end
