require_relative '../../../automated_init'

context "Raw Output" do
  context "Test" do
    output = Output::Raw.new

    control_fixture = Controls::Fixture.example(output)

    control_fixture.instance_exec do
      context "Pass" do
        test "Some test" do
          comment "Indentation Mark"

          assert(true)
        end

        test do
          comment "Indentation Mark"

          assert(true)
        end
      end

      context "Failure" do
        test "Some test" do
          comment "Indentation Mark"

          test_session.fail!
        end

        test do
          comment "Indentation Mark"

          test_session.fail!
        end
      end

      context "Skip" do
        test "Some test"

        test
      end
    end

    test do
      assert(output.writer.written?(<<TEXT))
Pass
  Starting test "Some test"
    Indentation Mark
  Some test
  Starting test
    Indentation Mark
  Test

Failure
  Starting test "Some test"
    Indentation Mark
  Some test (failed)
  Starting test
    Indentation Mark
  Test (failed)

Skip
  Some test (skipped)
  Test (skipped)

TEXT
    end
  end
end
