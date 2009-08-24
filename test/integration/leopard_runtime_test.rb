require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RubyEnterpriseEditionRuntimeTest < Test::Unit::TestCase

  def setup
    @root = File.join("/tmp", "test")
    @registry = RubyConfig::Registry.new(@root)
  end

  def teardown
    FileUtils.rm_rf(@root)
  end

  test "should install and use leopard runtime" do
    @registry.add(RubyConfig::Runtimes::LeopardRuntime)
    runtime = @registry.get("ruby-leopard-1.8.6")
    @registry.install(runtime)
        
    # use checks
    assert Pathname.new(File.join(@registry.ruby_config_path, "ruby")).symlink?
    assert Pathname.new(File.join(@registry.ruby_config_path, "gem")).symlink?
  end
  
end
