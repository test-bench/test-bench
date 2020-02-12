require_relative '../../../automated_init'

context "Output" do
  context "Session" do
    context "Fixture" do
      context "Verbose Mode" do
        output = Output::Session.new

        output.verbose = true

        output.writer.enable_styling!

        fixture_cls = Controls::Fixture.example_class do
          def inspect
            "#<Controls::Fixture::Example:0x#{object_id.to_s(16)}>"
          end
        end

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
          end
        end

        test do
          control_text = <<~TEXT
          \e[32mOuter Context\e[39m
            \e[36mStarting fixture (Fixture: #{fixture_1.class.inspect})\e[39m
              Some comment
              \e[35mFinished fixture (Fixture: #{fixture_1.class.inspect}, Result: pass)\e[39m
          \e[2;3;32mFinished context "Outer Context" (Result: pass)\e[39;23;22m

          \e[36mStarting fixture (Fixture: #{fixture_2.class.inspect})\e[39m
            Other comment
            \e[35mFinished fixture (Fixture: #{fixture_2.class.inspect}, Result: pass)\e[39m

          TEXT

          assert(output.writer.written?(control_text))
        end
      end
    end
  end
end
