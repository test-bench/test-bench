require_relative '../automated_init'

context "CLI" do
  context "Paths Specified Via Standard Input" do
    cli = CLI.new

    path_1 = Controls::Path.example
    path_2 = Controls::Path.random

    stdin = Controls::Stdin::Create.(path_1, path_2)
    cli.stdin = stdin

    cli.()

    context "Runs the paths written to standard input" do
      ran_path_1 = cli.run.path?(path_1)
      detail "Ran #{path_1}: #{ran_path_1}"

      ran_path_2 = cli.run.path?(path_2)
      detail "Ran #{path_2}: #{ran_path_2}"

      test do
        assert(ran_path_1 && ran_path_2)
      end
    end
  end
end
