require_relative '../../../automated_init'

context "Output" do
  context "Levels" do
    context "Debug Level" do
      context "Level Predicate" do
        output = Output::Levels::Debug.build

        context "Correct" do
          test do
            assert(output.level?(:debug))
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
