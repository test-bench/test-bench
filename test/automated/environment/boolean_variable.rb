require_relative '../automated_init'

context "Environment" do
  context "Boolean Variable" do
    env_var = 'TEST_BENCH_SOME_VAR'

    context "True" do
      [
        'on',
        'ON',
        'On',
        'yes',
        'YES',
        'Yes',
        'y',
        'Y',
        'true',
        'TRUE',
        'True',
        't',
        'T',
        '1'
      ].each do |text|
        env = { env_var => text }

        value = Environment::Boolean.fetch(env_var, env: env)

        test do
          assert(value == true)
        end
      end
    end

    context "False" do
      [
        'off',
        'OFF',
        'Off',
        'no',
        'NO',
        'No',
        'n',
        'N',
        'false',
        'FALSE',
        'False',
        'f',
        'F',
        '0'
      ].each do |text|
        env = { env_var => text }

        value = Environment::Boolean.fetch(env_var, env: env)

        test do
          assert(value == false)
        end
      end
    end

    context "Not Set" do
      env = {}

      context "Default Omitted" do
        value = Environment::Boolean.fetch(env_var, env: env)

        test "Returns nil" do
          assert(value.nil?)
        end
      end

      context "Default Given" do
        value = Environment::Boolean.fetch(env_var, :default, env: env)

        test "Returns the default that was given" do
          assert(value == :default)
        end
      end
    end

    context "Unknown" do
      env = { env_var => 'unknown' }

      test "Raises error" do
        assert_raises(Environment::Boolean::Error) do
          Environment::Boolean.fetch(env_var, env: env)
        end
      end
    end
  end
end
