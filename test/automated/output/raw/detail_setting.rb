require_relative '../../automated_init'

context "Raw Output" do
  context "Detail Setting" do
    passing_batch = Controls::Output::BatchData::Pass.example
    failing_batch = Controls::Output::BatchData::Failure.example

    context "Setting: Failure" do
      detail = Controls::Output::DetailSetting.failure

      raw_output = Output::Raw.new
      raw_output.detail_setting = detail

      context "No Current Batch" do
        show_details = raw_output.detail?

        test "Show details" do
          assert(show_details)
        end
      end

      context "Current Batch: Pass" do
        raw_output.current_batch = passing_batch

        hide_details = !raw_output.detail?

        test "Hide details" do
          assert(hide_details)
        end
      end

      context "Current Batch: Failure" do
        raw_output.current_batch = failing_batch

        show_details = raw_output.detail?

        test "Show details" do
          assert(show_details)
        end
      end
    end

    context "Setting: On" do
      detail = Controls::Output::DetailSetting.on

      raw_output = Output::Raw.new
      raw_output.detail_setting = detail

      context "No Batch" do
        show_details = raw_output.detail?

        test "Show details" do
          assert(show_details)
        end
      end

      context "Current Batch: Pass" do
        raw_output.current_batch = passing_batch

        show_details = raw_output.detail?

        test "Show details" do
          assert(show_details)
        end
      end

      context "Current Batch: Failure" do
        raw_output.current_batch = failing_batch

        show_details = raw_output.detail?

        test "Show details" do
          assert(show_details)
        end
      end
    end

    context "Setting: Off" do
      detail = Controls::Output::DetailSetting.off

      raw_output = Output::Raw.new
      raw_output.detail_setting = detail

      context "No Result" do
        hide_details = !raw_output.detail?

        test "Hide details" do
          assert(hide_details)
        end
      end

      context "Current Batch: Pass" do
        raw_output.current_batch = passing_batch

        hide_details = !raw_output.detail?

        test "Hide details" do
          assert(hide_details)
        end
      end

      context "Current Batch: Failure" do
        raw_output.current_batch = failing_batch

        hide_details = !raw_output.detail?

        test "Hide details" do
          assert(hide_details)
        end
      end
    end

    context "Invalid Setting" do
      detail = Controls::Output::DetailSetting::Invalid.example

      raw_output = Output::Raw.new

      test "Raises an error" do
        assert(Output::Raw::Error) do
          raw_output.detail_setting = detail
          raw_output.detail?
        end
      end
    end
  end
end
