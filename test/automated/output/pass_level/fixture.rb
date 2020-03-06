require_relative '../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Fixture" do
      output = Output::Levels::Pass.new

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
        Outer Context
          Some comment

        Other comment
        TEXT
      end
    end
  end
end
