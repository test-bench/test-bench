require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Indentation Depth" do
      writer = Output::Writer.new

      context "Increase" do
        writer.indentation_depth = 11

        writer.increase_indentation

        test do
          assert(writer.indentation_depth == 12)
        end
      end

      context "Decrease" do
        writer.indentation_depth = 11

        writer.decrease_indentation

        test do
          assert(writer.indentation_depth == 10)
        end
      end
    end
  end
end
