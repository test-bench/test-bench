require_relative '../automated_init'

context "CLI" do
  context "Standard Input And Argument Paths" do
    cli = CLI.new

    path_1 = Controls::Path.example
    path_2 = Controls::Path.alternate

    stdin = Controls::Device::Interactive::Non.example
    stdin.puts(path_1)
    stdin.rewind

    cli.stdin = stdin

    cli.argv = [path_2]

    cli.()

    context "Stdin Path: #{path_1}" do
      test do
        assert(cli.run.ran?(path_1))
      end
    end

    context "Argument Path: #{path_2}" do
      test do
        assert(cli.run.ran?(path_2))
      end
    end
  end
end
