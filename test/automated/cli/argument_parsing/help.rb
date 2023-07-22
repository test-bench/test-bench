require_relative '../../automated_init'

context "CLI" do
  context "Argument Parsing" do
    context "Help" do
      {
        "Short Form" => ['-h'],
        "Long Form" => ['--help']
      }.each do |prose, argv|
        context prose do
          cli = CLI.new(*argv)

          program_name = 'bench'
          cli.program_name = program_name

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
            Usage: #{program_name} [options] [paths]

            Informational Options:
            \t-h, --help                        Print this help message and exit successfully
            \t-v, --version                     Print version and exit successfully

            Configuration Options:
            \t-d, --[no]detail                  Always show (or hide) details (Default: #{Session::Output::Detail.default})
            \t-x, --[no-]exclude PATTERN        Do not execute test files matching PATTERN (Default: #{Run::GetFiles::Defaults.exclude_file_pattern.inspect})
            \t-f, --[no-]only-failure           Don't display output for test files that pass (Default: #{Run::Output::File::Defaults.only_failure ? 'on' : 'off'})
            \t-o, --output-styling [on|off|detect]
            \t                                  Render output coloring and font styling escape codes (Default: #{Output::Writer::Styling.default})
            \t-s, --seed NUMBER                 Sets pseudo-random number seed (Default: not set)

            Other Options:
            \t-r, --require LIBRARY             Require LIBRARY before running any files

            Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).

            If no paths are given, a default path (#{CLI::Defaults.tests_directory}) is scanned for test files.

            The following environment variables can also control execution:

            \tTEST_BENCH_DETAIL                 Same as -d or --detail
            \tTEST_BENCH_EXCLUDE_FILE_PATTERN   Same as -x or --exclude-file-pattern
            \tTEST_BENCH_ONLY_FAILURE           Same as -f or --only-failure
            \tTEST_BENCH_OUTPUT_STYLING         Same as -o or --output-styling
            \tTEST_BENCH_SEED                   Same as -s or --seed

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
