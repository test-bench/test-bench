module TestBench
  module Controls
    module Output
      module Summary
        module Error
          def self.example(writer: nil)
            error_summary = Example.new
            error_summary.writer = writer unless writer.nil?
            error_summary
          end

          class Example
            include TestBench::Fixture::Output
            include TestBench::Output::Summary::Error

            TestBench::Fixture::Output.instance_methods.each do |method|
              define_method(method) do |*|
              end
            end
          end

          module Text
            def self.example
              <<~TEXT
                Error Summary:
                   1: #{file}
                      #{error.backtrace[0]}: #{error} (#{error.class})

              TEXT
            end

            def self.file
              TestFile.filename
            end

            def self.error
              Controls::Error.example
            end
          end
        end
      end
    end
  end
end
