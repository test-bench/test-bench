require_relative '../automated_init'

context "CLI" do
  context "Help" do
    cli = CLI.new('--help')

    exit_code = cli.()

    output = cli.writer.written_text
    comment "Written Text:", output

    test "Exit code is zero" do
      assert(exit_code.zero?)
    end

    test "Didn't run any test files" do
      refute(cli.run.ran?)
    end
  end
end
