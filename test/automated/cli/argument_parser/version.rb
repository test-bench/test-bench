require_relative '../../automated_init'

context "CLI" do
  context "Argument Parser" do
    context "Version" do
      {
        "Short Form" => ['-V'],
        "Long Form" => ['--version']
      }.each do |prose, argv|
        context prose do
          argument_parser = CLI::ParseArguments.new(argv)

          argument_parser.output_device = StringIO.new

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
