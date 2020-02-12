require_relative '../../../automated_init'

context "Output" do
  context "Levels" do
    context "Failure Level" do
      context "Pass" do
        writer = Output::Writer::Substitute.build

        output = Output::Levels::Failure.build(writer: writer)

        control_fixture = Controls::Fixture.example(output)

        path_1 = Controls::Path.example
        path_2 = Controls::Path.alternate

        control_fixture.instance_exec do
          output.start

          output.enter_file(path_1)

          context "Some Context" do
            test "Some test" do
              assert(true)
            end

            test "Other test" do
              assert(true)
            end
          end

          output.exit_file(path_1, true)

          output.enter_file(path_2)

          context "Other Context" do
            test "Some test" do
              assert(true)
            end
          end

          output.exit_file(path_2, true)

          output.finish(true)
        end

        test "Writes nothing" do
          refute(writer.written?)
        end
      end
    end
  end
end
