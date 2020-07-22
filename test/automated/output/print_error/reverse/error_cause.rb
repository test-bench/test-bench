require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Reverse" do
      context "Error Cause" do
        writer = Output::Writer::Substitute.build

        error = Controls::Error.example(backtrace_depth: 5, cause: true)

        Output::PrintError.(error, writer: writer, reverse_backtraces: true)

        error_cause = error.cause or fail

        test do
          assert(writer.written?(<<TEXT))
Traceback (most recent call last):
\t2: from #{error_cause.backtrace[2]}
\t1: from #{error_cause.backtrace[1]}
#{error_cause.backtrace[0]}: #{error_cause.message} (#{error_cause.class.name})
\t4: from #{error.backtrace[4]}
\t3: from #{error.backtrace[3]}
\t2: from #{error.backtrace[2]}
\t1: from #{error.backtrace[1]}
#{error.backtrace[0]}: #{error.message} (#{error.class.name})
TEXT
        end
      end
    end
  end
end
