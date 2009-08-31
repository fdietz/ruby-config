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
  
  test "should call do_install on runtime and cleanup tmp directory afterwards" do
    @runtime.expects(:do_install)
    @installer.expects(:cleanup_tmp_dir)
    @installer.install(@runtime)
  end  

  test "should install rubygems, post_install on runtime and install ruby-config gem" do
    @runtime.expects(:post_install)
    
    @installer.rubygems.expects(:installed?).returns(false)
    @installer.rubygems.expects(:install).with(@runtime)
    @installer.rubygems.expects(:gem_install).with(RubyConfig::Installer::RUBY_CONFIG_GEM_NAME)
    
    @installer.post_install(@runtime)
  end  

  test "should skip rubygems install if already installed" do
    @runtime.stubs(:post_install)
    @installer.rubygems.stubs(:gem_install)
    
    @installer.rubygems.expects(:installed?).returns(true)
    @installer.rubygems.expects(:install).never
    
    @installer.post_install(@runtime)
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
