require_relative '../../automated_init'

context "Run" do
  context "Substitute" do
    context "Loaded Predicate" do
      substitute = Run::Substitute.build

      path_1 = Controls::Path.example
      path_2 = Controls::Path.alternate

      substitute.load(path_1)

      context "Path Was Loaded" do
        test do
          assert(substitute.loaded?(path_1))
        end
      end

      context "Path Was Not Loaded" do
        test do
          refute(substitute.loaded?(path_2))
        end
      end
    end
  end
end
