require_relative '../../../automated_init'

context "Output" do
  context "Levels" do
    context "Summary Level" do
      context "Level Predicate" do
        output = Output::Levels::Summary.build

        context "Correct" do
          test do
            assert(output.level?(:summary))
          end
        end

        context "Incorrect" do
          test do
            refute(output.level?(:incorrect_level))
          end
        end
      end
    end
  end
end
