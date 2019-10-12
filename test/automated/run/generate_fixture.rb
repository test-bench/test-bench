require_relative '../automated_init'

context "Run" do
  context "Generate Fixture" do
    run = Run.new

    fixture = Run.fixture(run)

    test "Returns a fixture" do
      assert(fixture.is_a?(Fixture))
    end

    test "Configures test run dependency" do
      assert(fixture.test_run.equal?(run))
    end

    context "Variant: _context" do
      context "Title Given" do
        fixture._context("Some Context") do
          #
        end

        test "Skips the given context" do
          skipped = run.output.recorded_once?(:skip_context) do |title|
            title == "Some Context"
          end

          assert(skipped)
        end
      end

      context "Title Omitted" do
        fixture._context do
          #
        end

        test "Skips the given context" do
          skipped = run.output.recorded_once?(:skip_context) do |title|
            title.nil?
          end

          assert(skipped)
        end
      end
    end

    context "Variant: _test" do
      context "Title Given" do
        fixture._test("Some test") do
          #
        end

        test "Skips the given test" do
          skipped = run.output.recorded_once?(:skip_test) do |title|
            title == "Some test"
          end

          assert(skipped)
        end
      end

      context "Title Omitted" do
        fixture._test do
          #
        end

        test "Skips the given test" do
          skipped = run.output.recorded_once?(:skip_test) do |title|
            title.nil?
          end

          assert(skipped)
        end
      end
    end
  end
end
