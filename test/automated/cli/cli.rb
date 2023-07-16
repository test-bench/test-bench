require_relative '../automated_init'

context "CLI" do
  cli = CLI.new

  result = Controls::Result.pass
  cli.run.set_result(result)

  random_seed = Controls::Random::Seed.example
  random_seed_text = Controls::Random::Seed.text
  cli.random.set_seed(random_seed)

  exit_code = cli.()

  context "Exit Code" do
    comment exit_code.inspect

    test "Zero" do
      assert(exit_code.zero?)
    end
  end

  context "Written Text" do
    writer = cli.writer

    written_text = writer.written_text
    control_text = <<~TEXT
    #{RUBY_DESCRIPTION}
    Random Seed: #{random_seed_text}

    TEXT

    comment written_text
    detail "Control:", control_text

    test do
      assert(writer.written?(control_text))
    end
  end
end
