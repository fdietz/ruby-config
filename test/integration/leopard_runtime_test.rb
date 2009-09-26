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

  test "should install and use leopard runtime" do
    runtime = RubyConfig::Runtimes::LeopardRuntime.new(runtime_install_path, tmp_path)
    @installer.install(runtime)
  end
  
  
  private 
    def runtime_install_path
      File.join(@root, 'runtimes')
    end

    def tmp_path
      File.join(@root, 'tmp')
    end
  
end
