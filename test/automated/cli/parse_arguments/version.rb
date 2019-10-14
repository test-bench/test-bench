require_relative '../../automated_init'

context "CLI" do
  context "Parse Arguments" do
    context "Version" do
      {
        "Short Form" => ['-V'],
        "Long Form" => ['--version']
      }.each do |prose, argv|
        context prose do
          parse_arguments = CLI::ParseArguments.new(argv)

          parse_arguments.output_device = StringIO.new

          begin
            parse_arguments.()
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
