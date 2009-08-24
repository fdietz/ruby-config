require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RubyEnterpriseEditionRuntimeTest < Test::Unit::TestCase

  def setup
    @root = File.join("/tmp", "test")
    @registry = RubyConfig::Registry.new(@root)
  end

  def teardown
    FileUtils.rm_rf(@root)
  end

  test "should install and use ruby enterprise edition runtime" do
    @registry.add(RubyConfig::Runtimes::RubyEnterpriseEditionRuntime)
    runtime = @registry.get("ruby-enterprise-1.8.6")
    @registry.install(runtime)
    
    # install checks
    assert File.exist?(runtime.ruby_home_path)
    assert File.exist?(runtime.gem_home_path)
    assert File.exist?(File.join(runtime.ruby_bin_path, "ruby"))
    assert File.exist?(File.join(runtime.ruby_bin_path, "gem"))
    assert File.exist?(File.join(runtime.ruby_bin_path, "irb"))    
    
    # use checks
    assert Pathname.new(File.join(@registry.ruby_config_path, "ruby")).symlink?
    assert Pathname.new(File.join(@registry.ruby_config_path, "gem")).symlink?
  end
  
end
