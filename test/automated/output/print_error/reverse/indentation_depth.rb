require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      context "Indentation Depth" do
        writer = Output::Writer::Substitute.build
        writer.indentation_depth = 2

        error = Controls::Error.example

        Output::PrintError.(error, writer: writer, reverse_backtraces: true)

        test do
          assert(writer.written?(<<-TEXT))
    Traceback (most recent call last):
\t    2: from #{error.backtrace[2]}
\t    1: from #{error.backtrace[1]}
    #{error.backtrace[0]}: #{error.message} (#{error.class.name})
          TEXT
        end
      end
    end
  end
end
