require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Exclude File Pattern" do
      pattern_text = Controls::Pattern.text

      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-x', pattern_text])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_EXCLUDE_FILE_PATTERN'] == pattern_text)
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--exclude', pattern_text])

        argument_parser.()

        test do
          assert(argument_parser.env['TEST_BENCH_EXCLUDE_FILE_PATTERN'] == pattern_text)
        end
      end

      context "Long Form, Negated" do
        argument_parser = CLI::ParseArguments.new(['--no-exclude'])

        argument_parser.()

        test do
          none_pattern_text = Controls::Pattern::None.example

          assert(argument_parser.env['TEST_BENCH_EXCLUDE_FILE_PATTERN'] == none_pattern_text)
        end
      end

      context "Invalid Text" do
        argument_parser = CLI::ParseArguments.new(['--exclude', Controls::Pattern::Invalid.text])

        test "Raises an error" do
          assert_raises(CLI::ParseArguments::Error) do
            argument_parser.()
          end
        end
      end
    end
  end
end
