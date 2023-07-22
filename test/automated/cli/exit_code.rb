require_relative '../automated_init'

context "Exit Code" do
  context "Pass" do
    result = Controls::Result.pass

    exit_code = CLI.exit_code(result)

    comment exit_code.inspect

    test "Zero" do
      assert(exit_code == 0)
    end
  end

  context "Not Passed" do
    failed_exit_code = nil

    context "Failed" do
      result = Controls::Result.failure

      exit_code = CLI.exit_code(result)
      failed_exit_code = exit_code

      comment exit_code.inspect

      test "Non Zero" do
        refute(exit_code == 0)
      end
    end

    context "Unknown" do
      result = Object.new

      exit_code = CLI.exit_code(result)

      comment exit_code.inspect

      test "Non Zero" do
        refute(exit_code == 0)
      end

      test "Different from failed exit code" do
        refute(exit_code == failed_exit_code)
      end
    end
  end
end
