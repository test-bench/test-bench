require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Log Level" do
      level_text = Controls::Output::LogLevel.example.to_s

      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-l', level_text])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_LOG_LEVEL'] == level_text)
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--log-level', level_text])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_LOG_LEVEL'] == level_text)
        end
      end

      context "Invalid Text" do
        invalid_level_text = Controls::Output::LogLevel::Invalid.example.to_s

        argument_parser = CLI::ParseArguments.new(['--log-level', invalid_level_text])

        test "Raises an error" do
          assert_raises(Fixture::Output::Log::Error) do
            argument_parser.()
          end
        end
      end
    end
  end
end
