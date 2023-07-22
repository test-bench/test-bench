require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Seed" do
      context do
        seed_text = '1111'

        context "Short Form" do
          cli = CLI.new('-s', seed_text)
          cli.parse_arguments

          env_text = cli.env['TEST_BENCH_SEED']

          comment env_text.inspect

          test do
            assert(env_text == seed_text)
          end
        end

        context "Long Form" do
          cli = CLI.new('--seed', seed_text)
          cli.parse_arguments

          env_text = cli.env['TEST_BENCH_SEED']

          comment env_text.inspect

          test do
            assert(env_text == seed_text)
          end
        end
      end

      context "Not an Integer" do
        seed_text = 'not-an-integer'

        cli = CLI.new('--seed', seed_text)

        test "Is an error" do
          assert_raises(CLI::ArgumentError) do
            cli.parse_arguments
          end
        end
      end

      context "No Value" do
        context "Final Argument" do
          cli = CLI.new('--seed')

          test "Is an error" do
            assert_raises(CLI::ArgumentError) do
              cli.parse_arguments
            end
          end
        end

        context "Next Argument Is An Option" do
          cli = CLI.new('--seed', '-')

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
