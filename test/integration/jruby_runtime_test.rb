require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RubyEnterpriseEditionRuntimeTest < Test::Unit::TestCase

  def setup
    @root = "/tmp/ruby-config"
    @installer = RubyConfig::Installer.new(@root)
    @switcher = RubyConfig::Switcher.new(@root)
  end

  def teardown
    FileUtils.rm_rf(@root)
  end

  test "should install and use jruby runtime" do
    runtime = RubyConfig::Runtimes::JRubyRuntime.new(runtime_install_path, tmp_path)
    @installer.install(runtime)
            
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
  end
  
  private 
    def runtime_install_path
      File.join(@root, 'runtimes')
    end

    def tmp_path
      File.join(@root, 'tmp')
    end
  
end
