require_relative '../../../automated_init'

context "Output" do
  context "Levels" do
    context "Pass Level" do
      context "Level Predicate" do
        output = Output::Levels::Pass.build

        context "Correct" do
          test do
            assert(output.level?(:pass))
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
