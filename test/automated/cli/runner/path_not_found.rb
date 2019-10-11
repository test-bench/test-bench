require_relative '../../automated_init'

context "CLI" do
  context "Runner" do
    context "Path Not Found" do
      runner = CLI::Run.new

      path = Controls::Path.example

      test "Raises error" do
        assert_raises(CLI::Run::Error) do
          runner.() do |paths|
            paths << path
          end
        end
      end
    end
  end
end
