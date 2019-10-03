require_relative '../../../automated_init'

context "Output" do
  context "Writer" do
    context "Escape Code" do
      context "Unknown Code" do
        code_id = :unknown

        writer = Output::Writer.new

        test "Raises an error" do
          assert_raises(Output::Writer::Error) do
            writer.escape_code(code_id)
          end
        end
      end
    end
  end
end
