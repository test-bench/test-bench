require_relative '../../automated_init'

context "Run" do
  context "Substitute" do
    context "Finished Predicate" do
      context "Run Finished" do
        substitute = Run::Substitute.build

        substitute.finish

        result = !substitute.failed?

        context "Optional Result Argument Omitted" do
          test "Returns true" do
            assert(substitute.finished? == true)
          end
        end

        context "Optional Result Argument Given" do
          context "Given Result Matches Run Result" do
            test "Returns true" do
              assert(substitute.finished?(result) == true)
            end
          end

          context "Given Result Does Not Match Run Result" do
            test "Returns false" do
              assert(substitute.finished?(!result) == false)
            end
          end
        end
      end

      context "Run Not Finished" do
        substitute = Run::Substitute.build

        test do
          assert(substitute.finished? == false)
        end
      end
    end
  end
end
