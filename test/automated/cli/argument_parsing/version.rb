require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Version" do
      {
        "Short Form" => ['-v'],
        "Long Form" => ['--version']
      }.each do |prose, argv|
        context prose do
          cli = CLI.new(*argv)

          version = '1.2.3'
          cli.version = version

          cli.parse_arguments

          context "Exit Code" do
            exit_code = cli.exit_code

            comment exit_code.inspect

            test "Zero" do
              assert(exit_code.zero?)
            end
          end

          context "Written Text" do
            written_text = cli.writer.written_text
            control_text = <<~TEXT
            TestBench Version: #{version}
            TEXT

            comment written_text
            detail "Control:", control_text

            test do
              assert(cli.writer.written?(control_text))
            end
          end
        end
      end
    end
  end
end
