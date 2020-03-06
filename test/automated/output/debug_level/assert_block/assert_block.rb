require_relative '../../../automated_init'

context "Output" do
  context "Debug Level" do
    context "Assert Block" do
      output = Output::Levels::Debug.new

      output.writer.enable_styling!

      caller_location_1 = Controls::CallerLocation.example
      caller_location_2 = Controls::CallerLocation::Alternate.example

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        context "Some Context" do
          test "Pass" do
            assert(caller_location: caller_location_1) do
              comment "Comment #1"
              assert(true)
            end
          end

          test "Failure" do
            assert(caller_location: caller_location_2) do
              comment "Comment #2"
            end
          end
        end
      end

      test do
        assert(output.writer.written?(<<~TEXT))
        \e[32mSome Context\e[39m
          \e[36mStarting test "Pass"\e[39m
            \e[34mEntered assert block (Caller Location: #{caller_location_1})\e[39m
              Comment #1
            \e[36mExited assert block (Caller Location: #{caller_location_1}, Result: pass)\e[39m
          \e[32mFinished test \e[1m"Pass"\e[22m (Result: pass)\e[39m
          \e[36mStarting test "Failure"\e[39m
            \e[34mEntered assert block (Caller Location: #{caller_location_2})\e[39m
              Comment #2
            \e[36mExited assert block (Caller Location: #{caller_location_2}, Result: failure)\e[39m
        \e[31m    #{caller_location_2}: \e[1mAssertion failed (\e[4mTestBench::Fixture::AssertionFailure\e[24m)\e[22m
        \e[39m  \e[31mFinished test \e[1m"Failure"\e[22m (Result: failure)\e[39m
        \e[2;3;31mFinished context "Some Context" (Result: failure)\e[39;23;22m

        TEXT
      end
    end
  end
end
