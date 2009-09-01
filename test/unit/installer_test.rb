require File.join(File.dirname(__FILE__), '..', 'test_helper')

class InstallerTest < Test::Unit::TestCase
  
  def setup
    @root = "/tmp/ruby-config"
    FileUtils.mkdir(@root)
    
    @runtime = RuntimeBaseTestHelper::RuntimeBaseStub.new(File.join(@root, "install"), File.join(@root, "tmp"))
    @installer = RubyConfig::Installer.new(@root)
  end
  
  def teardown
    FileUtils.rm_rf(@root)
  end

  test "should create config directories" do
    @installer = RubyConfig::Installer.new(@root)
    File.exists?(@installer.runtime_install_path)
    File.exists?(@installer.tmp_path)
  end  
    
end

module RuntimeBaseTestHelper
  class RuntimeBaseStub < RubyConfig::RuntimeBase
    def install;end
    def archive_file_name;"filename";end
    def archive_download_url;"http://download.com";end
    def handle;"handle";end
    def description;"description";end
  end
end
