require_relative '../../../automated_init'

context "Output" do
  context "Levels" do
    context "Summary Level" do
      context "Pass" do
        writer = Output::Writer::Substitute.build

        timer = Output::Timer::Substitute.build

        output = Output::Levels::Summary.build(writer: writer, timer: timer)

        control_fixture = Controls::Fixture.example(output)

        path_1 = Controls::Path.example
        path_2 = Controls::Path.alternate

        control_fixture.instance_exec do
          output.start

          output.enter_file(path_1)

          context "Some Context" do
            test "Some test" do
              assert(true)
            end

            test "Other test" do
              assert(true)
            end
          end

          output.exit_file(path_1, true)

          output.enter_file(path_2)

          context "Other Context" do
            test "Some test" do
              assert(true)
            end
          end

          output.exit_file(path_2, true)

          output.finish(true)
        end

        test "Writes errors and error summary" do
          error = Controls::Error.example

          control_text = <<~TEXT
          Finished running 2 files
          Ran 3 tests in 0.000s (0.0 tests/second)
          3 passed, 0 skipped, 0 failed, 0 total errors

          TEXT

          assert(writer.written?(control_text))
        end
      end
    end
  end
end
