module TestBench
  class CLI
    class Run
      def test_run
        @test_run ||= TestBench::Run::Substitute.build
      end
      attr_writer :test_run

      def call
        test_run.start

        test_run.finish
      end
    end
  end
end
