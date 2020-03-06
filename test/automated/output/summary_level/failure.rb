require_relative '../../automated_init'

context "Output" do
  context "Summary Level" do
    context "Failure" do
      output = Output::Levels::Summary.new

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

      test "Writes error summary, then run summary" do
        assert(output.writer.written?(<<~TEXT))
        #{Controls::Output::Summary::Error::Text.example.chomp}
        #{Controls::Output::Summary::Run::Text::Failure.example.chomp}
        TEXT
      end
    end
  end
end
