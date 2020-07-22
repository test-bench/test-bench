require_relative '../../automated_init'

context "Raw Output" do
  context "Comment" do
    output = Output::Raw.new

    output.writer.enable_styling!

    control_fixture = Controls::Fixture.example(output)

    control_fixture.instance_exec do
      context "Some Context" do
        comment "Some comment"
      end
    end

    test do
      assert(output.writer.written?(<<TEXT))
\e[32mSome Context\e[39m
  Some comment

TEXT
    end
  end
end
