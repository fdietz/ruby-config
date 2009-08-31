require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RuntimeBaseTest < Test::Unit::TestCase

  def setup
    @root = "/tmp/ruby-config"
    FileUtils.mkdir(@root)
    FileUtils.mkdir(File.join(@root, 'tmp'))
    @runtime = RuntimeBaseTestHelper::RuntimeBaseStub.new(File.join(@root, "runtimes"), File.join(@root, "tmp"))
  end

  def teardown
    FileUtils.rm_rf(@root)
  end

  test "should set install path" do
    r = RuntimeBaseTestHelper::RuntimeBaseStub.new("/install", "/tmp_path")
    assert_equal "/install/handle", r.install_path
  end  

  test "should return true if ruby bin found" do
    FileUtils.mkdir_p(File.join(@runtime.ruby_bin_path))
    bin_path = File.join(@runtime.ruby_bin_path, "ruby")
    FileUtils.touch(bin_path)

    assert_equal true, @runtime.already_installed?
  end

  test "should return false if ruby bin NOT found" do
    assert_equal false, @runtime.already_installed?
  end

  test "should download archive unless it exist already" do 
    @runtime.stubs(:create_directory_structure)

    @runtime.expects(:download_archive)
    @runtime.prepare_install
  end

  test "should NOT download archive if it exists already" do
    @runtime.stubs(:create_directory_structure)

    FileUtils.touch(@runtime.archive_path)

    @runtime.expects(:download_archive).never
    @runtime.prepare_install
  end

  test "should create initial directory structure" do
    @runtime.create_directory_structure

    assert File.exists?(@runtime.ruby_bin_path)
    assert File.exists?(@runtime.gem_home_path)
  end

  test "should call prepare_install and then install" do
    @runtime.expects(:prepare_install)
    @runtime.expects(:install)

    @runtime.do_install
  end

  test "should delete runtime directories" do
    create_fake_runtime_directories
    @runtime.delete

    assert !File.exists?(@runtime.ruby_home_path)
    assert !File.exists?(@runtime.gem_home_path)
  end

  private
  def create_fake_runtime_directories
    FileUtils.mkdir_p(@runtime.ruby_home_path)
    FileUtils.mkdir_p(@runtime.gem_home_path)
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
