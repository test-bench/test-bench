require_relative '../../../automated_init'

context "CLI" do
  context "Run" do
    context "Substitute" do
      path_1 = '/path/1.rb'
      path_2 = '/path/2.rb'
      path_3 = '/path/3.rb'

      substitute = CLI::Run::Substitute.build
      refute(substitute.ran?)

      substitute.() do |paths|
        paths << path_1
        paths << path_2
      end

      context "Ran Predicate" do
        context "No Paths Given" do
          test "Returns true" do
            assert(substitute.ran? == true)
          end
        end

        context "All Given Paths Were Ran" do
          test "Returns true" do
            assert(substitute.ran?(path_1, path_2) == true)
          end
        end

        context "Some Given Paths Were Not Ran" do
          test "Returns false" do
            assert(substitute.ran?(path_1, path_3) == false)
          end
        end

        context "No Given Paths Were Ran" do
          test "Returns false" do
            assert(substitute.ran?(path_3) == false)
          end
        end
      end
    end
  end
end
