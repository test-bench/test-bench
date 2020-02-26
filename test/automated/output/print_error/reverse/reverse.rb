require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      writer = Output::Writer::Substitute.build

      error = Controls::Error.example

      Output::PrintError.(error, writer: writer, reverse_backtraces: true)

      test "Writes error message to device" do
        assert(writer.written?(<<TEXT))
Traceback (most recent call last):
\t2: from #{error.backtrace[2]}
\t1: from #{error.backtrace[1]}
#{error.backtrace[0]}: #{error.message} (#{error.class.name})
TEXT
      end
    end
  end
end
