require_relative '../../../automated_init'

context "Output" do
  context "Session" do
    context "Test" do
      output = Output::Session.new

      output.writer.enable_styling!

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        context "Some Context" do
          test "Pass" do
            comment "Text #1"
          end

          test "Skip"

          test "Failure" do
            comment "Text #2"

            test_sesion.fail!
          end
        end
      end

      test do
        control_text = <<~TEXT
        \e[32mSome Context\e[39m
            Text #1
          \e[32mPass\e[39m
          \e[33mSkip\e[39m
            Text #2
          \e[1;31mFailure\e[22;39m

        TEXT

        assert(output.writer.written?(control_text))
      end
    end
  end
end
