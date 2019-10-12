require_relative '../automated_init'

context "CLI" do
  context "Standard Input Contains Paths" do
    cli = CLI.new

    path_1 = Controls::Path.example
    path_2 = Controls::Path.alternate

    stdin = Controls::Device::Interactive::Non.example
    stdin.write(<<~TEXT)
    #{path_1}
    #{path_2}
    TEXT
    stdin.rewind

    cli.stdin = stdin

    cli.()

    context "Path: #{path_1}" do
      test do
        assert(cli.run.ran?(path_1))
      end
    end

    context "Path: #{path_2}" do
      test do
        assert(cli.run.ran?(path_2))
      end
    end
  end
end
