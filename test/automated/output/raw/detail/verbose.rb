require_relative '../../../automated_init'

context "Raw Output" do
  context "Detail" do
    context "Verbose" do
      context "Detail Setting: On" do
        output = Output::Raw.new

        output.verbose = true

        output.detail_setting = :on

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          detail "Some detail"
        end

        test do
          assert(output.writer.written?(<<TEXT))
Some detail
TEXT
        end
      end

      context "Detail Setting: Off" do
        output = Output::Raw.new

        output.verbose = true

        output.detail_setting = :off

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          detail "Some detail"
        end

        test do
          assert(output.writer.written?(<<TEXT))
(detail omitted: Some detail)
TEXT
        end
      end
    end
  end
end
