module TestBench
  module Output
    module Summary
      class Run
        include Output

        def elapsed_time
          @elapsed_time ||= 0
        end
        attr_writer :elapsed_time

        def file_count
          @file_count ||= 0
        end
        attr_writer :file_count

        def timer
          @timer ||= Timer::Substitute.build
        end
        attr_writer :timer

        def enter_file(_)
          timer.start

          self.file_count += 1
        end
      end
    end
  end
end
