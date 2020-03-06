require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Dependency Module" do
      cls = Class.new do
        include Output::Writer::Dependency
      end

      context "Default Attribute" do
        obj = cls.new

        writer = obj.writer or fail

        test "Is a substitute" do
          assert(writer.instance_of?(Output::Writer::Substitute::Writer))
        end
      end

      context "Override Attribute" do
        obj = cls.new

        writer = Output::Writer.new

        obj.writer = writer

        test do
          assert(obj.writer.equal?(writer))
        end
      end
    end
  end
end
