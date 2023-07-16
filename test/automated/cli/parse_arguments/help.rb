require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Help" do
      {
        "Short Form" => ['-h'],
        "Long Form" => ['--help']
      }.each do |prose, argv|
        context prose do
          argument_parser = CLI::ParseArguments.new(argv)

          begin
            argument_parser.()
          rescue SystemExit => system_exit
          end

          test "Exits process" do
            refute(system_exit.nil?)
          end

          test "Exit code indicates success" do
            assert(system_exit.status.zero?)
          end
        end
      end
    end
  end
end
