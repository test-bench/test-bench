require_relative '../../../automated_init'

context "Output" do
  context "Levels" do
    context "Debug Level" do
      writer = Output::Writer::Substitute.build

      timer = Output::Timer::Substitute.build

      output = Output::Levels::Debug.build(writer: writer, timer: timer)

      control_fixture = Controls::Fixture.example(output)

      path_1 = Controls::Path.example
      path_2 = Controls::Path.alternate

      error_1 = Controls::Error.example("Error #1")
      error_2 = Controls::Error.example("Error #2")
      error_3 = Controls::Error.example("Error #3")

      control_fixture.instance_exec do
        output.start

        output.enter_file(path_1)

        context "Some Context" do
          test "Some test" do
            raise error_1
          end

          test "Other test" do
            raise error_2
          end
        end

        output.exit_file(path_1, false)

        output.enter_file(path_2)

        context "Other Context" do
          test "Some test" do
            raise error_3
          end
        end

        output.exit_file(path_2, false)

        output.finish(false)
      end

      test "Writes errors and error summary" do
        error = Controls::Error.example

        control_text = <<~TEXT
        Running #{path_1}
        Some Context
          Starting test "Some test"
          Some test
            #{error_1.backtrace[0]}: #{error_1.message} (#{error_1.class})
        \t    from #{error_1.backtrace[1]}
        \t    from #{error_1.backtrace[2]}
          Starting test "Other test"
          Other test
            #{error_2.backtrace[0]}: #{error_2.message} (#{error_2.class})
        \t    from #{error_2.backtrace[1]}
        \t    from #{error_2.backtrace[2]}
        Finished context "Some Context" (Result: failure)

        Running #{path_2}
        Other Context
          Starting test "Some test"
          Some test
            #{error_3.backtrace[0]}: #{error_3.message} (#{error_3.class})
        \t    from #{error_3.backtrace[1]}
        \t    from #{error_3.backtrace[2]}
        Finished context "Other Context" (Result: failure)

        Error Summary:
           2: #{path_1}
              #{error_1.backtrace[0]}: #{error_1.message} (#{error_1.class})
              #{error_2.backtrace[0]}: #{error_2.message} (#{error_2.class})
           1: #{path_2}
              #{error_3.backtrace[0]}: #{error_3.message} (#{error_3.class})

        Finished running 2 files
        Ran 3 tests in 0.000s (0.0 tests/second)
        0 passed, 0 skipped, 3 failed, 3 total errors

        TEXT

        assert(writer.written?(control_text))
      end
    end
  end
end
