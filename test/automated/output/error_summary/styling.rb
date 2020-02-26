require_relative '../../automated_init'

context "Output" do
  context "Error Summary" do
    context "Failure" do
      context "Styling" do
        writer = Output::Writer::Substitute.build
        writer.enable_styling!

        output = Controls::Output::Summary::Error.example(writer: writer)

        file = Controls::Output::Summary::Error::Text.file
        error = Controls::Output::Summary::Error::Text.error

        output.start

        output.enter_file(file)
        output.error(error)
        output.exit_file(file, false)

        output.finish(false)

        test do
          assert(output.writer.written?(<<~TEXT))
            \e[1;31mError Summary:\e[22;39m
               1: #{file}
                  \e[31m#{error.backtrace[0]}: \e[1m#{error} (\e[4m#{error.class}\e[24m)\e[22m
            \e[39m
          TEXT
        end
      end
    end
  end
end
