require_relative '../../automated_init'

context "Output" do
  context "Summary Level" do
    context "Pass" do
      output = Output::Levels::Summary.new

      control_fixture = Controls::Fixture.example(output)

      file = Controls::TestFile.filename

      control_fixture.instance_exec do
        test_session.start

        output.enter_file(file)

        context "Some Context" do
          test "Some test" do
            assert(true)
          end
        end

        output.exit_file(file, true)

        test_session.finish
      end

      control_text = Controls::Output::Summary::Run::Text::Pass.example

      test "Writes run summary" do
        assert(output.writer.written?(control_text))
      end
    end
  end
end
