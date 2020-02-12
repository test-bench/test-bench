require_relative '../automated_init'

context "Output" do
  output = Controls::Output.example

  Controls::Output::Exercise.each_method do |method_name, args|
    test "Method: #{method_name}" do
      refute_raises(NoMethodError) do
        output.public_send(method_name, *args)
      end
    end
  end
end
