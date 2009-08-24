require File.join(File.dirname(__FILE__), '..', 'test_helper')
  
class RegistryInitializeTest < Test::Unit::TestCase
  def setup
    @root = File.join("/tmp", "test")
    @registry = RubyConfig::Registry.new(@root)
  end
  
  def teardown
    FileUtils.rm_rf(@root)
  end
  
  test "should ensure config directories exist" do
    assert File.exist?(@root)
    assert File.exist?(File.join(@root,"runtimes"))
    assert File.exist?(File.join(@root,"tmp"))
  end
      
end


class RegistryInstallTest < Test::Unit::TestCase
  
  def setup
    @root = File.join("/tmp", "test")
    @registry = RubyConfig::Registry.new(@root)
    @registry.add(RegistryTestHelper::RuntimeBaseStub)
    @runtime = @registry.get("handle")
  end

  def teardown
    FileUtils.rm_rf(@root)
  end
  
  test "should install using specific runtime implementation" do
    @registry.install(@runtime)

    assert File.exist?(@runtime.ruby_home_path)
    assert File.exist?(@runtime.gem_home_path)
    assert File.exist?(File.join(@runtime.ruby_bin_path, "ruby"))
    assert File.exist?(File.join(@runtime.ruby_bin_path, "gem"))
    assert File.exist?(File.join(@runtime.ruby_bin_path, "irb"))
  end
  
  test "should make use of installed runtime" do
    @registry.expects(:use).with(@runtime)
    @registry.install(@runtime)
  end
  
  test "should call post install methods" do
    @runtime.expects(:post_install)
    @registry.install(@runtime)
  end
end


class RegistryUseTest < Test::Unit::TestCase
  
  def setup
    @root = File.join("/tmp", "test")
    @registry = RubyConfig::Registry.new(@root)
    @registry.add(RegistryTestHelper::RuntimeBaseStub)
    @runtime = @registry.get("handle")
    @registry.install(@runtime)
  end
  
  def teardown
    FileUtils.rm_rf(@root)
  end
  
  test "should set default handle in config file" do
    @registry.use(@runtime)
    
    config = File.open(File.join(@registry.ruby_config_path, "config.yml")) { |yf| YAML::load( yf ) }
    assert_equal @runtime.handle, config["default"]
  end
  
  test "should create symlinks to installed runtime" do
    @registry.use(@runtime)
    assert Pathname.new(File.join(@registry.ruby_config_path, "ruby")).symlink?
    assert Pathname.new(File.join(@registry.ruby_config_path, "gem")).symlink?
  end
end

module RegistryTestHelper
  
  class RuntimeBaseStub < RubyConfig::RuntimeBase
    # create fake ruby and gem executables
    def install
      FileUtils.touch(File.join(ruby_bin_path, "ruby"))
      FileUtils.touch(File.join(ruby_bin_path, "gem"))
      FileUtils.touch(File.join(ruby_bin_path, "irb"))
    end
  
    def archive_file_name;"archive.zip";end
    def archive_download_url;"http://download.com/archive.zip";end
    def handle;"handle";end
    def description;"description";end
    # no download for tests
    def download_file_unless_exists(archive, url);end;
  end
  
end
