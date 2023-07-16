require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Seed" do
      seed_text = '1111'

      context "Short Form" do
        argument_parser = CLI::ParseArguments.new(['-s', seed_text])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_SEED']

        comment env_text.inspect

        test do
          assert(env_text == seed_text)
        end
      end

      context "Long Form" do
        argument_parser = CLI::ParseArguments.new(['--seed', seed_text])
        argument_parser.()

        env_text = argument_parser.env['TEST_BENCH_SEED']

        comment env_text.inspect

        test do
          assert(env_text == seed_text)
        end
      end
    end
  end
end
