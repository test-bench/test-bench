require_relative '../automated_init'

context "Run" do
  context "Finish" do
    context "Run Passed" do
      run = Run.new

      run.finish

      context "Output" do
        result = true

        test "Finish run" do
          recorded = run.output.recorded_once?(:finish_run) do |r|
            r == result
          end

          assert(recorded)
        end
      end
    end

    context "Run Failed" do
      run = Run.new

      run.test do
        run.assert(false)
      end

      run.finish

      context "Output" do
        result = false

        test "Finish run" do
          recorded = run.output.recorded_once?(:finish_run) do |r|
            r == result
          end

          assert(recorded)
        end
      end
    end
  end
end
