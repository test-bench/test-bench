module TestBench
  module Output
    module Summary
      class Error
        include Output

        def files
          @files ||= []
        end

        def current_file
          files.last
        end

        def writer
          @writer ||= Writer::Substitute.build
        end
        attr_writer :writer

        def enter_file(path)
          file = File.build(path)

          files << file
        end

        def exit_file(path, result)
          if result
            files.pop
          end
        end

        def error(error)
          unless current_file.nil?
            current_file.error(error)
          end
        end

        def finish(_)
          return if files.empty?

          writer
            .escape_code(:bold)
            .escape_code(:red)
            .text('Error Summary:')
            .escape_code(:reset_intensity)
            .escape_code(:reset_fg)
            .newline

          files.each do |file|
            path, errors = file.to_a

            error_count = errors.count

            writer
              .text(error_count.to_s.rjust(4, ' '))
              .text(": #{path}")
              .newline

            errors.each do |error|
              location = error.backtrace[0]

              writer
                .text("      ")
                .escape_code(:red)
                .text("#{location}: ")
                .escape_code(:bold)
                .text("#{error.message} (#{error.class})")
                .escape_code(:reset_intensity)
                .escape_code(:reset_fg)
                .newline
            end
          end

          writer.newline
        end

        File = Struct.new(:path, :errors) do
          def self.build(path)
            new(path, [])
          end

          def error(error)
            self.errors << error
          end
        end
      end
    end
  end
end
