module TestBench
  module Output
    module Summary
      class Run
        include Output

        def elapsed_time
          @elapsed_time ||= 0
        end
        attr_writer :elapsed_time

        def error_count
          @error_count ||= 0
        end
        attr_writer :error_count

        def file_count
          @file_count ||= 0
        end
        attr_writer :file_count

        def failure_count
          @failure_count ||= 0
        end
        attr_writer :failure_count

        def pass_count
          @pass_count ||= 0
        end
        attr_writer :pass_count

        def test_count
          @test_count ||= 0
        end
        attr_writer :test_count

        def timer
          @timer ||= Timer::Substitute.build
        end
        attr_writer :timer

        def enter_file(_)
          timer.start

          self.file_count += 1
        end

        def exit_file(_, _)
          elapsed_time = timer.stop

          self.elapsed_time += elapsed_time

          elapsed_time
        end

        def error(error)
          self.error_count += 1
        end

        def finish_test(_, result)
          self.test_count += 1

          if result
            self.pass_count += 1
          else
            self.failure_count += 1
          end
        end
      end
    end
  end
end
