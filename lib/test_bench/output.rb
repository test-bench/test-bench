module TestBench
  module Output
    def self.build(log_level: nil, writer: nil, device: nil, styling: nil, **buffer_output_args)
      summary = Summary.build(writer: writer, device: device, styling: styling)

      log_output = Log.build(level: log_level)

      writer = summary.writer

      buffer_output = Buffer.build(writer: writer, **buffer_output_args)

      Fixture::Output::Multiple.build(
        log_output,
        buffer_output,
        summary
      )
    end

    Substitute = Fixture::Output::Substitute
  end
end
