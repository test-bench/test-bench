require_relative '../../../automated_init'

context "Raw Output" do
  context "Fixture" do
    context "Verbose" do
      output = Output::Raw.new

      output.verbose = true

      output.writer.enable_styling!

      fixture_cls = Controls::Fixture.example_class

      fixture_1 = nil
      fixture_2 = nil

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        fixture_1 = fixture(fixture_cls) do
          comment "Indentation Mark"
        end

        fixture_2 = fixture(fixture_cls) do
          comment "Indentation Mark"

          test_session.fail!
        end
      end

      test do
        assert(output.writer.written?(<<TEXT))
\e[34mStarting fixture (Fixture: #{fixture_1.class.inspect})\e[39m
  Indentation Mark
\e[35mFinished fixture (Fixture: #{fixture_1.class.inspect}, Result: pass)\e[39m
\e[34mStarting fixture (Fixture: #{fixture_2.class.inspect})\e[39m
  Indentation Mark
\e[35mFinished fixture (Fixture: #{fixture_2.class.inspect}, Result: failure)\e[39m
TEXT
      end
    end
  end
end
