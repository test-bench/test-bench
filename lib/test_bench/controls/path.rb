module TestBench
  module Controls
    module Path
      def self.example
        TestFile.filename
      end

      def self.alternate
        TestFile::Alternate.filename
      end

      Directory = Controls::Directory

      module TestFile
        def self.example(filename: nil, text: nil, directory: nil)
          filename ||= self.filename
          text ||= text

          basename, extension, _ = filename.partition('.rb')

          file = Tempfile.new([basename, extension], directory)
          file.write(text)
          file.close

          tempfiles << file

          file.path
        end

        def self.filename
          'some_test_file.rb'
        end

        def self.text
          'assert(true)'
        end

        def self.tempfiles
          @tempfiles ||= []
        end

        module Alternate
          def self.example
            Path.example(filename: filename)
          end

          def self.filename
            'other_test_file.rb'
          end
        end

        module Pass
          def self.example(directory: nil)
            TestFile.example(filename: filename, directory: directory)
          end

          def self.filename
            'some_passing_test.rb'
          end
        end

        module Failure
          def self.example(directory: nil)
            TestFile.example(text: text, filename: filename, directory: directory)
          end

          def self.filename
            'some_passing_test.rb'
          end

          def self.text
            'refute(true)'
          end
        end
      end
    end
  end
end
