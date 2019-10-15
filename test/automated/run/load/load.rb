require_relative '../../automated_init'

context "Run" do
  context "Load" do
    path = Controls::Path::TestFile.example

    run = Run.new

    result = run.load(path)

    context "Output" do
      test "Enter file" do
        recorded = run.output.recorded_once?(:enter_file) do |p|
          p == path
        end

        assert(recorded)
      end

      test "Exit file" do
        recorded = run.output.recorded_once?(:exit_file) do |p, r|
          p == path && r == result
        end

        assert(recorded)
      end
    end
  end
end
