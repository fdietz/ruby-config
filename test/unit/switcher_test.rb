require File.join(File.dirname(__FILE__), '..', 'test_helper')

class SwitcherTest < Test::Unit::TestCase
  
  def setup
    @root = "/tmp/ruby-config"
    FileUtils.mkdir(@root)
    
    @runtime = RuntimeBaseTestHelper::RuntimeBaseStub.new(File.join(@root, "runtimes"), File.join(@root, "tmp"))
    @switcher = RubyConfig::Switcher.new(@root)
  end
  
  def teardown
    FileUtils.rm_rf(@root)
  end

  test "should set default handle to selected runtime handle" do
    @switcher.config.stubs(:save)
    @switcher.stubs(:set_symlinks_to_runtime)
    
    @switcher.switch(@runtime)
    
    assert_equal 'handle', @switcher.config.default_handle
  end  
  
  test "should set symlinks to ruby and gem" do
    @switcher.stubs(:set_default_handle)
    @switcher.stubs(:delete_existing_symlinks)
    
    create_fake_ruby_and_gem_directories
    @switcher.switch(@runtime)
    
    assert File.exists?(ruby_path)
    assert File.exists?(gem_path)
  end  
  
  test "should delete obsolete existing symlinks" do
    @switcher.stubs(:set_default_handle)
    
    create_fake_ruby_and_gem_directories
    create_fake_ruby_and_gem_symlinks
    
    @switcher.switch(@runtime)
    assert File.exists?(ruby_path)
    assert File.exists?(gem_path)
  end
  
  private
    def create_fake_ruby_and_gem_directories
      FileUtils.mkdir_p(@runtime.ruby_home_path)
      FileUtils.mkdir_p(@runtime.gem_home_path)
    end
    
    def create_fake_ruby_and_gem_symlinks
      FileUtils.ln_s(@runtime.ruby_home_path, ruby_path)
      FileUtils.ln_s(@runtime.gem_home_path, gem_path)
    end
    
    def ruby_path
      File.join(@root, 'ruby')
    end
    
    def gem_path
      File.join(@root, 'gem')
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
