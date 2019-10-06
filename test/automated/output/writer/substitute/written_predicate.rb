require_relative '../../../automated_init'

context "Output" do
  context "Writer" do
    context "Substitute" do
      context "Written Predicate" do
        context "Some Text Written" do
          substitute = Output::Writer::Substitute.build

          substitute.text("Some text")

          context "No Argument" do
            test "Returns true" do
              assert(substitute.written? == true)
            end
          end

          context "String Argument" do
            context "Exact Match" do
              test "Returns true" do
                assert(substitute.written?("Some text") == true)
              end
            end

            context "Partial Match" do
              test "Returns false" do
                assert(substitute.written?("Some") == false)
              end
            end

            context "Non Match" do
              test "Returns false" do
                assert(substitute.written?("Other text") == false)
              end
            end
          end

          context "Pattern Argument" do
            context "Match" do
              test "Returns false" do
                assert(substitute.written?(/./) == true)
              end
            end

            context "Non Match" do
              test "Returns false" do
                assert(substitute.written?(/$^/) == false)
              end
            end
          end
        end

        context "Nothing Written" do
          context "No Argument" do
            substitute = Output::Writer::Substitute.build

            test "Returns false" do
              assert(substitute.written? == false)
            end
          end
        end
      end
    end
  end
end
