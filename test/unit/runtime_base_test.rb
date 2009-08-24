require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RuntimeBaseInitializeTest < Test::Unit::TestCase
  
  test "should set install path" do
    r = RuntimeBaseTestHelper::RuntimeBaseStub.new("/install", "/tmp_path")
    assert_equal "/install/handle", r.install_path
  end  
end

class RuntimeBaseDoInstallTest < Test::Unit::TestCase
  
  def setup
    @root = "/tmp/test"
    FileUtils.mkdir(@root)
  end
  
  def teardown
    FileUtils.rm_rf(@root)
  end
  
  test "should create directory structure" do
    r = RuntimeBaseTestHelper::RuntimeBaseStub.new(File.join(@root, "install"), File.join(@root, "tmp"))
    r.stubs(:download_file_unless_exists)
    r.stubs(:already_installed?).returns(true)
    r.do_install
    
    assert File.exist?(r.install_path)
    assert File.exist?(r.tmp_path)
    assert File.exist?(File.join(r.install_path,"gem"))
  end  
  
  test "should install runtime and cleanup tmp unless installed already" do
    r = RuntimeBaseTestHelper::RuntimeBaseStub.new(File.join(@root, "install"), File.join(@root, "tmp"))
    r.stubs(:download_file_unless_exists)
    r.stubs(:already_installed?).returns(false)
    
    r.expects(:install).once
    r.expects(:cleanup_tmp_dir).once  
    r.do_install
  end
  
  test "should NOT install runtime if installed already" do
    r = RuntimeBaseTestHelper::RuntimeBaseStub.new(File.join(@root, "install"), File.join(@root, "tmp"))
    r.stubs(:download_file_unless_exists)
    r.stubs(:already_installed?).returns(true)
    
    r.expects(:install).never
    r.expects(:cleanup_tmp_dir).never
    r.do_install
  end
  
end

class RuntimeBaseDownloadFileUnlessExists < Test::Unit::TestCase
  
  def setup
    @root = "/tmp/test"
    FileUtils.mkdir(@root)
    
    @runtime = RuntimeBaseTestHelper::RuntimeBaseStub.new(File.join(@root, "install"), File.join(@root, "tmp"))
    @runtime.send(:create_directory_structure)
  end
  
  def teardown
    FileUtils.rm_rf(@root)
  end
  
  test "should download file unless it exist already" do
    @runtime.expects(:download_file_wget).once    
    @runtime.send(:download_file_unless_exists, "archive.zip", "url")    
  end
  
  test "should NOT download file if it exists already" do
    archive_path = File.join(@runtime.tmp_path, "archive.zip")
    FileUtils.touch(archive_path)
    @runtime.expects(:download_file_wget).never
    
    @runtime.send(:download_file_unless_exists, "archive.zip", "url")
  end

end

class RuntimeBaseIfAlreadyInstalledTest < Test::Unit::TestCase
  
  def setup
    @root = "/tmp/test"
    FileUtils.mkdir(@root)
    
    @runtime = RuntimeBaseTestHelper::RuntimeBaseStub.new(File.join(@root, "install"), File.join(@root, "tmp"))
    @runtime.send(:create_directory_structure)
    FileUtils.mkdir_p(@runtime.ruby_bin_path)
  end
  
  def teardown
    FileUtils.rm_rf(@root)
  end
  
  test "should return true if ruby bin found" do
    bin_path = File.join(@runtime.ruby_bin_path, "ruby")
    FileUtils.touch(bin_path)
    
    assert_equal true, @runtime.already_installed?
  end
    
  test "should return false if ruby bin NOT found" do
    assert_equal false, @runtime.already_installed?
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
