require_relative '../../../automated_init'

context "Raw Output" do
  context "Context" do
    output = Output::Raw.new

    control_fixture = Controls::Fixture.example(output)

    control_fixture.instance_exec do
      context "Outer Context" do
        context "Pass" do
          #
        end

        context "Failure" do
          test_session.fail!
        end

        context "Skip"
      end
    end

    test do
      assert(output.writer.written?(<<TEXT))
Outer Context
  Pass
  Failure
  Skip

TEXT
    end
  end
end
