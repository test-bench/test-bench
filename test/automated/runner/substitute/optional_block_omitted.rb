require_relative '../../automated_init'

context "Runner" do
  context "Substitute" do
    context "Optional Block Omitted" do
      substitute = Run::Substitute.build
      refute(substitute.ran?)

      substitute.()

      test "Ran predicate returns true" do
        assert(substitute.ran? == true)
      end
    end
  end
end
