require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RubyEnterpriseEditionRuntimeTest < Test::Unit::TestCase

  def setup
    @root = File.join("/tmp", "test")
    @registry = RubyConfig::Registry.new(@root)
  end

  def teardown
    FileUtils.rm_rf(@root)
  end

  test "should install and use jruby runtime" do
    @registry.add(RubyConfig::Runtimes::JRubyRuntime)
    runtime = @registry.get("jruby-1.3.1")
    @registry.install(runtime)
    
    # install checks
    assert File.exist?(runtime.ruby_home_path)
    assert File.exist?(runtime.gem_home_path)
    assert File.exist?(File.join(runtime.ruby_bin_path, "jruby"))
    assert File.exist?(File.join(runtime.ruby_bin_path, "gem"))
    assert File.exist?(File.join(runtime.ruby_bin_path, "jirb"))    
    assert Pathname.new(File.join(runtime.ruby_bin_path, "jruby")).executable?
    assert Pathname.new(File.join(runtime.ruby_bin_path, "jirb")).executable?
    assert Pathname.new(File.join(runtime.ruby_bin_path, "ruby")).symlink?
    assert Pathname.new(File.join(runtime.ruby_bin_path, "irb")).symlink?
    
    # use checks
    assert Pathname.new(File.join(@registry.ruby_config_path, "ruby")).symlink?
    assert Pathname.new(File.join(@registry.ruby_config_path, "gem")).symlink?
  end
  
end
