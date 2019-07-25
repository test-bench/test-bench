require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Exclude File Pattern" do
      pattern_text = Controls::Pattern.text
      control_pattern = Controls::Pattern.example

      context "Short Form" do
        parse_arguments = CLI::ParseArguments.new(['-x', pattern_text])

        parse_arguments.()

        test do
          assert(parse_arguments.run.exclude_file_pattern == control_pattern)
        end
      end

      context "Long Form" do
        parse_arguments = CLI::ParseArguments.new(['--exclude', pattern_text])

        parse_arguments.()

        test do
          assert(parse_arguments.run.exclude_file_pattern == control_pattern)
        end
      end

      context "Long Form, Negated" do
        parse_arguments = CLI::ParseArguments.new(['--no-exclude'])

        parse_arguments.()

        test do
          assert(parse_arguments.run.exclude_file_pattern == Controls::Pattern::None.example)
        end
      end

      context "Invalid Text" do
        parse_arguments = CLI::ParseArguments.new(['--exclude', Controls::Pattern::Invalid.text])

        test "Raises an error" do
          assert_raises(CLI::ParseArguments::Error) do
            parse_arguments.()
          end
        end
      end
    end
  end
end
