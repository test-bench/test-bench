require_relative '../../automated_init'

context "CLI" do
  context "Runner" do
    test_run = TestBench::Run::Substitute.build

    tests_directory = Controls::Directory.example

    fixture(
      Fixtures::ConfigureReceiver,
      CLI::Run,
      tests_directory,
      test_run: test_run,
      attr_name: :run
    )
  end
end
