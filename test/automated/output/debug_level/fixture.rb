require_relative '../../automated_init'

context "Output" do
  context "Debug Level" do
    context "Fixture" do
      output = Output::Levels::Debug.new

      output.writer.enable_styling!

      fixture_cls = Controls::Fixture.example_class

      fixture_1 = nil
      fixture_2 = nil

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        context "Outer Context" do
          fixture_1 = fixture(fixture_cls) do
            comment "Some comment"
          end
        end

        fixture_2 = fixture(fixture_cls) do
          comment "Other comment"

          test_session.fail!
        end
      end

      test do
        assert(output.writer.written?(<<~TEXT))
        \e[32mOuter Context\e[39m
          \e[34mStarting fixture (Fixture: #{fixture_1.class.inspect})\e[39m
            Some comment
          \e[35mFinished fixture (Fixture: #{fixture_1.class.inspect}, Result: pass)\e[39m
        \e[2;3;32mFinished context "Outer Context" (Result: pass)\e[39;23;22m

        \e[34mStarting fixture (Fixture: #{fixture_2.class.inspect})\e[39m
          Other comment
        \e[35mFinished fixture (Fixture: #{fixture_2.class.inspect}, Result: failure)\e[39m

        TEXT

      end
    end
  end
end
