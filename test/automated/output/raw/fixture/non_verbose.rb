require_relative '../../../automated_init'

context "Raw Output" do
  context "Fixture" do
    context "Non Verbose" do
      output = Output::Raw.new

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
Indentation Mark
Indentation Mark
TEXT
      end
    end
  end
end
