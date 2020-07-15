require_relative '../../../automated_init'

context "Raw Output" do
  context "Load File" do
    output = Output::Raw.new

    output.writer.enable_styling!

    path = Controls::TestFile.filename

    result = Controls::Result.example

    output.enter_file(path)

    output.enter_context("Some Context")
    output.exit_context("Some Context", result)

    output.exit_file(path, result)

    test do
      assert(output.writer.written?(<<~TEXT))
      Running #{path}
      \e[32mSome Context\e[39m

      TEXT
    end
  end
end
