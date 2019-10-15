require_relative '../../automated_init'

context "Run" do
  context "Load" do
    context "Failure" do
      path = Controls::Path::TestFile::Failure.example

      run = Run.new

      return_value = run.load(path)

      test "Returns false" do
        assert(return_value == false)
      end
    end
  end
end
