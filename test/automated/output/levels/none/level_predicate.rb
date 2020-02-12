require_relative '../../../automated_init'

context "Output" do
  context "Levels" do
    context "None Level" do
      context "Level Predicate" do
        output = Output::Levels::None.new

        context "Correct" do
          test do
            assert(output.level?(:none))
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
