require File.join(File.dirname(__FILE__), '..', 'test_helper')

class Ruby186RuntimeTest < Test::Unit::TestCase

  def setup
    @root = "/tmp/ruby-config"
    @installer = RubyConfig::Installer.new(@root)
    @switcher = RubyConfig::Switcher.new(@root)
  end

  def teardown
    #FileUtils.rm_rf(@root)
  end

  test "should install and use ruby 186 runtime" do
    runtime = RubyConfig::Runtimes::Ruby186Runtime.new(runtime_install_path, tmp_path)
    puts runtime.class
    #@installer.install(runtime)
    
    @switcher.switch(runtime)
    @installer.post_install(runtime)
    
    # install checks
    assert File.exist?(runtime.ruby_home_path)
    assert File.exist?(runtime.gem_home_path)
    assert File.exist?(runtime.ruby_executable_path)
    puts runtime.class
    puts "gem path: #{runtime.gem_executable_path}"
    assert File.exist?(runtime.gem_executable_path)
    assert File.exist?(runtime.irb_executable_path)    
    
    # use checks
    assert Pathname.new(File.join(@root, "ruby")).symlink?
    assert Pathname.new(File.join(@root, "gem")).symlink?
  end
  
  private 
    def runtime_install_path
      File.join(@root, 'runtimes')
    end

    def tmp_path
      File.join(@root, 'tmp')
    end
  
end
