require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Class Actuator" do
      path_1 = Controls::Path.example
      path_2 = Controls::Path.random

      argv = ['--exclude', 'some-pattern', path_1, path_2]

      env = {}

      extra_arguments = CLI::ParseArguments.(argv, env:)

      test "Parses arguments" do
        assert(env['TEST_BENCH_EXCLUDE_FILE_PATTERN'] == 'some-pattern')
      end

      test "Returns extra arguments" do
        assert(extra_arguments == [path_1, path_2])
      end
    end
  end
end
