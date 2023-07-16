require_relative '../automated_init'

context "CLI" do
  context "No Paths Specified" do
    cli = CLI.new

    cli.()

    context "Default path is run" do
      default_path = CLI::Defaults.tests_directory

      test do
        assert(cli.run.path?(default_path))
      end
    end
  end
end
