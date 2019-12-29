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

        def enter_file(path)
          file = File.build(path)

          files << file
        end

        def error(error)
          unless current_file.nil?
            current_file.error(error)
          end
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
