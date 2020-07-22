require_relative './interactive_init'

output = TestBench::Output::Buffer.build

path_1 = Controls::TestFile.path
path_2 = Controls::TestFile.path

fixture = Controls::Fixture.example(output)

fixture.instance_exec do
  test_session.start

  output.enter_file(path_1)
  context "All Tests Pass" do
    detail "Detail #1"

    context "Some Context" do
      detail "Detail #2"

      test "Some test" do
        assert(true)
      end

      test "Some other test" do
        detail "Detail #3"

        assert(true)
      end

      test "Skipped test"
    end

    context "Other Context (Test has no title)" do
      test do
        assert(true)
      end
    end
  end
  output.exit_file(path_1, true)

  output.enter_file(path_2)
  context "Some Tests Fail" do
    detail "Detail #1"

    context "Some Context" do
      detail "Detail #2"

      test "Some test" do
        assert(true)
      end

      test "Some other (failing) test" do
        detail "Detail #3"

        refute(true)
      end

      test "Skipped test"
    end

    context "Other Context (Test has no title)" do
      test do
        refute(true)
      end
    end
  end
  output.exit_file(path_2, false)

  test_session.finish
end
