require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Class Actuator" do
      path_1 = Controls::Path.example
      path_2 = Controls::Path.alternate

      argv = ['-a', path_1, path_2]

      env = {
        'TEST_BENCH_ABORT_ON_ERROR' => 'off'
      }

      return_value = CLI::ParseArguments.(argv, env: env)

      test "Parses arguments" do
        assert(env['TEST_BENCH_ABORT_ON_ERROR'] == 'on')
      end

      test "Returns extra arguments" do
        assert(return_value == [path_1, path_2])
      end
    end
  end
end
