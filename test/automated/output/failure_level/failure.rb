require_relative '../../automated_init'

context "Output" do
  context "Failure Level" do
    context "Failure" do
      output = Output::Levels::Failure.new

      file = Controls::Output::Summary::Error::Text.file
      error = Controls::Output::Summary::Error::Text.error

      control_fixture = Controls::Fixture.example(output)

      control_fixture.instance_exec do
        test_session.start

        output.enter_file(file)

        context "Some Context" do
          test "Some test" do
            raise error
          end
        end

        output.exit_file(file, false)

        test_session.finish
      end

      test "Writes error, then error summary" do
        assert(output.writer.written?(<<~TEXT))
        #{Controls::Error::Text.example}
        #{Controls::Output::Summary::Error::Text.example.chomp}
        TEXT
      end
    end
  end
end
