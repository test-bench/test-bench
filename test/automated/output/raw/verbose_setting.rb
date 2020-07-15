require_relative '../../automated_init'

context "Raw Output" do
  context "Verbose Setting" do
    context "On" do
      output = Output::Raw.new

      output.verbose = true

      test do
        assert(output.verbose?)
      end
    end

    context "Off" do
      output = Output::Raw.new

      output.verbose = false

      test do
        refute(output.verbose?)
      end
    end
  end
end
