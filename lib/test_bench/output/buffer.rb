module TestBench
  module Output
    class Buffer < Fixture::Output::Capture
      attr_accessor :writer

      def raw_output
        @raw_output ||= Raw.new
      end
      attr_writer :raw_output

      def stack
        @stack ||= []
      end

      def self.build(verbose: nil, detail: nil, omit_backtrace_pattern: nil, reverse_backtraces: nil, writer: nil, device: nil, styling: nil)
        instance = new

        raw_output = Raw.configure(instance, verbose: verbose, detail: detail, omit_backtrace_pattern: omit_backtrace_pattern, reverse_backtraces: reverse_backtraces, writer: writer, device: device, styling: styling)

        instance.writer = raw_output.writer

        instance
      end

      def exit_context(*)
        super

        flush unless buffering?
      end

      def finish_test(*)
        super

        flush unless buffering?
      end

      def finish_fixture(*)
        super

        flush unless buffering?
      end

      def new_record(signal, data)
        record = Record.new(signal, data)

        case signal
        when :enter_context, :start_test, :start_fixture
          start_batch(record)

        when :exit_context, :finish_test, :finish_fixture
          result = record.data.last

          finish_batch(record, result)
        end

        record
      end

      def start_batch(record)
        record.start_batch(stack_depth)

        stack.push(record)
      end

      def finish_batch(final_record, result)
        first_record = stack.pop

        batch_data = first_record.batch_data
        batch_data.result = result

        final_record.batch_data = first_record.batch_data
      end

      def flush
        records.each do |record|
          record.forward(raw_output)
        end

        records.clear
      end

      def buffering?
        stack_depth.nonzero?
      end

      def stack_depth
        stack.length
      end

      class Record < Fixture::Output::Capture::Record
        attr_accessor :batch_data

        def forward(raw_output)
          return super if batch_data.nil?

          raw_output.public_send(signal, *data, batch_data: batch_data)
        end

        def start_batch(depth)
          batch_data = Output::BatchData.new
          batch_data.depth = depth

          self.batch_data = batch_data
        end

        def finish_batch(result)
          batch_data.result = result
        end
      end
    end
  end
end
