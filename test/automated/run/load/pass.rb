require_relative '../../automated_init'

context "Run" do
  context "Load" do
    context "Pass" do
      path = Controls::Path::TestFile::Pass.example

      run = Run.new

      return_value = run.load(path)

      test "Returns true" do
        assert(return_value == true)
      end
    end
  end
end
