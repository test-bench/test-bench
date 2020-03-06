require_relative '../../automated_init'

context "Output" do
  context "Run Summary" do
    writer = Output::Writer::Substitute.build

    Output::Summary::Run.(writer: writer)

    control_text = Controls::Output::Summary::Run::Text.example

    test "Prints summary" do
      assert(writer.written?(control_text))
    end
  end
end
