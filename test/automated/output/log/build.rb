require_relative '../../automated_init'

context "Log Output" do
  context "Build" do
    log = Output::Log.build

    test do
      assert(log.instance_of?(Fixture::Output::Log))
    end

    context "Default Level" do
      level = log.logger.level

      test "Fatal" do
        assert(level == Logger::FATAL)
      end
    end
  end
end
