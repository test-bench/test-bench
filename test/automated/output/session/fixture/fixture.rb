require_relative '../../../automated_init'

context "Output" do
  context "Session" do
    context "Fixture" do
      output = Output::Session.new

      fixture_cls = Controls::Fixture.example_class

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        context "Outer Context" do
          fixture(fixture_cls) do
            comment "Some comment"
          end
        end

        fixture(fixture_cls) do
          comment "Other comment"
        end
      end

      test do
        control_text = <<~TEXT
        Outer Context
          Some comment

        Other comment
        TEXT

        assert(output.writer.written?(control_text))
      end
    end
  end
end
