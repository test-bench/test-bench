require_relative '../automated_init'

context "CLI" do
  cli = CLI.new

  cli.()

  test "Invokes runner" do
    assert(cli.run.ran?)
  end
end
