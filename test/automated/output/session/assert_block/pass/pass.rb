require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Pass" do
        output = Output::Session.new

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          assert do
            comment "Some text"

            assert(true)
          end
        end

        test "Does not print any output from assert block" do
          refute(output.writer.written?)
        end
      end
    end
  end
end
