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

        File = Struct.new(:path, :errors) do
          def self.build(path)
            new(path, [])
          end
        end
      end
    end
  end
end
