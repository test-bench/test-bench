require_relative '../../../automated_init'

context "Output" do
  context "Pass Level" do
    context "Assert Block" do
      context "Nesting" do
        output = Output::Levels::Pass.new

        caller_location_1 = Controls::CallerLocation.example(line_number: 1)
        caller_location_2 = Controls::CallerLocation.example(line_number: 11)
        caller_location_3 = Controls::CallerLocation.example(line_number: 111)
        caller_location_4 = Controls::CallerLocation.example(line_number: 1111)

        control_fixture = Controls::Fixture.example(output)

        control_fixture.instance_exec do
          test "Example failure" do
            assert(caller_location: caller_location_1) do
              context "Inner Context" do
                comment "Comment #1"

                test "Inner test (pass)" do
                  assert do
                    comment "Comment #2"

                    assert(true)
                  end
                end

                test "Inner test (failure)" do
                  assert(caller_location: caller_location_2) do
                    context "Deep Inner Context" do
                      comment "Comment #3"

                      test "Deep inner test (pass)" do
                        assert do
                          comment "Comment #4"

                          assert(true)
                        end
                      end

                      test "Deep inner test (failure)" do
                        assert(caller_location: caller_location_3) do
                          comment "Comment #5"

                          assert(caller_location: caller_location_4) do
                            comment "Comment #6"

                            session.fail!
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end

        test do
          assert(output.writer.written?(<<~TEXT))
          Example failure
            #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
              Inner Context
                Comment #1
                Inner test (pass)
                Inner test (failure)
                  #{caller_location_2}: Assertion failed (TestBench::Fixture::AssertionFailure)
                    Deep Inner Context
                      Comment #3
                      Deep inner test (pass)
                      Deep inner test (failure)
                        #{caller_location_3}: Assertion failed (TestBench::Fixture::AssertionFailure)
                          Comment #5
                          #{caller_location_4}: Assertion failed (TestBench::Fixture::AssertionFailure)
                            Comment #6
          TEXT
        end
      end
    end
  end
end
