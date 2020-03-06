require_relative '../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Session" do
      file = Controls::TestFile.filename

      context "Pass" do
        output = Output::Levels::Pass.new

        result = Controls::Result::Pass.example

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          test_session.start

          output.enter_file(file)

          test "Some test" do
            assert(true)
          end

          output.exit_file(file, result)

          test_session.finish
        end

        control_text = Controls::Output::Summary::Run::Text::Pass.example

        control_pattern = Regexp.new(Regexp.escape(control_text))

        test do
          assert(output.writer.written?(control_pattern))
        end
      end

      context "Failure" do
        output = Output::Levels::Pass.new

        error = Controls::Error.example

        result = Controls::Result::Failure.example

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          test_session.start

          output.enter_file(file)

          test "Some test" do
            raise error
          end

          output.exit_file(file, result)

          test_session.finish
        end

        control_text = <<~TEXT
        #{Controls::Output::Summary::Error::Text.example.chomp}
        #{Controls::Output::Summary::Run::Text::Failure.example.chomp}
        TEXT

        control_pattern = Regexp.new(Regexp.escape(control_text))

        test do
          assert(output.writer.written?(control_pattern))
        end
      end
    end
  end
end
