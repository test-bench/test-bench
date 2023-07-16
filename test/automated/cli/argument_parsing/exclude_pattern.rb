require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Exclude Pattern" do
      pattern_text = 'some-pattern'

      context "Short Form" do
        cli = CLI.new('-x', pattern_text)
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_EXCLUDE_FILE_PATTERN']

        comment env_text.inspect

        test do
          assert(env_text == pattern_text)
        end
      end

      context "Long Form" do
        cli = CLI.new('--exclude', pattern_text)
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_EXCLUDE_FILE_PATTERN']

        comment env_text.inspect

        test do
          assert(env_text == pattern_text)
        end
      end

      context "Long Form, Negated" do
        cli = CLI.new('--no-exclude')
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_EXCLUDE_FILE_PATTERN']

        comment env_text.inspect

        test "Empty" do
          assert(env_text.empty?)
        end
      end

      context "Multiple Pattern" do
        other_pattern_text = 'some-other-pattern'

        cli = CLI.new('-x', pattern_text, '-x', other_pattern_text)
        cli.parse_arguments

        env_text = cli.env['TEST_BENCH_EXCLUDE_FILE_PATTERN']
        control_env_text = "#{pattern_text},#{other_pattern_text}"

        comment env_text.inspect
        detail "Control: #{control_env_text.inspect}"

        test do
          assert(env_text == control_env_text)
        end
      end

      context "No Value" do
        context "Final Argument" do
          cli = CLI.new('--exclude')

          test "Is an error" do
            assert_raises(CLI::ArgumentError) do
              cli.parse_arguments
            end
          end
        end

        context "Next Argument Is An Option" do
          cli = CLI.new('--exclude', '-')

          test "Is an error" do
            assert_raises(CLI::ArgumentError) do
              cli.parse_arguments
            end
          end
        end
      end
    end
  end
end
