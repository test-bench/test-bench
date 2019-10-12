require_relative '../../automated_init'

context "Run" do
  context "Substitute" do
    context "Started Predicate" do
      context "Run Started" do
        substitute = Run::Substitute.build

        substitute.start

        test do
          assert(substitute.started? == true)
        end
      end

      context "Run Not Started" do
        substitute = Run::Substitute.build

        test do
          assert(substitute.started? == false)
        end
      end
    end
  end
end
