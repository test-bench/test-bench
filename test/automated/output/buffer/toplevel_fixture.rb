require_relative '../../automated_init'

context "Buffered Output" do
  context "Toplevel Fixture" do
    context "Pass" do
      buffered_output = Output::Buffer.new

      control_fixture = Controls::Fixture.example(buffered_output)
      control_fixture.instance_exec do
        test "Some test" do
          detail "Some detail"

          assert(true)
        end
      end

      test "Does not show details" do
        assert(buffered_output.raw_output.writer.written?(<<TEXT))
Some test
TEXT
      end
    end

    context "Failure" do
      buffered_output = Output::Buffer.new

      caller_location = Controls::CallerLocation.example

      control_fixture = Controls::Fixture.example(buffered_output)
      control_fixture.instance_exec do
        test "Some test" do
          detail "Some detail"

          assert(false, caller_location: caller_location)
        end
      end

      test "Shows details" do
        assert(buffered_output.raw_output.writer.written?(<<TEXT))
Some test (failed)
  Some detail
  #{Controls::Error::Text::Assertion.example.chomp}
TEXT
      end
    end
  end
end
