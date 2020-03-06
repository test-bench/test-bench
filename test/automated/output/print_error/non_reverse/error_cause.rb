require_relative '../../../automated_init'

context "Output" do
  context "Print Error" do
    context "Non Reverse" do
      context "Error Cause" do
        writer = Output::Writer::Substitute.build

        error = Controls::Error.example(backtrace_depth: 5, cause: true)

        Output::PrintError.(error, writer: writer, reverse_backtraces: false)

        error_cause = error.cause or fail

        test do
          assert(writer.written?(<<~TEXT))
            #{error.backtrace[0]}: #{error.message} (#{error.class.name})
            \tfrom #{error.backtrace[1]}
            \tfrom #{error.backtrace[2]}
            \tfrom #{error.backtrace[3]}
            \tfrom #{error.backtrace[4]}
            #{error_cause.backtrace[0]}: #{error_cause.message} (#{error_cause.class.name})
            \tfrom #{error_cause.backtrace[1]}
            \tfrom #{error_cause.backtrace[2]}
          TEXT
        end
      end
    end
  end
end
