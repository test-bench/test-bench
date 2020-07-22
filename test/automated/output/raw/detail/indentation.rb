require_relative '../../../automated_init'

context "Raw Output" do
  context "Detail" do
    context "Indentation" do
      output = Output::Raw.new

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        context "Some Context" do
          detail "Some detail"
        end
      end

      test do
        assert(output.writer.written?(<<TEXT))
Some Context
  Some detail

TEXT
      end
    end
  end
end
