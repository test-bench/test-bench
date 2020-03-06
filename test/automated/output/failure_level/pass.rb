require_relative '../../automated_init'

context "Output" do
  context "Failure Level" do
    context "Pass" do
      output = Output::Levels::Failure.new

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

      test "Writes nothing" do
        refute(output.writer.written?)
      end
    end
  end
end
