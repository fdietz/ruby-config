require File.join(File.dirname(__FILE__), '..', 'test_helper')
  
class RegistryTest < Test::Unit::TestCase
  def setup
    @registry = RubyConfig::Registry.new("/tmp/ruby-config")
  end
    
  test "should list all available runtimes" do
    @registry.add(RubyConfig::Runtimes::LeopardRuntime)
    
    assert_equal 1, @registry.list_available.size
  end
  
  test "should list all installed runtimes" do
    @registry.add(RubyConfig::Runtimes::LeopardRuntime)
    
    @registry.list.first.expects(:already_installed?).returns(true)
    assert_equal 1, @registry.list_installed.size
  end

  test "should return runtime based on handle" do
    @registry.add(RubyConfig::Runtimes::LeopardRuntime)
    
    assert_equal @registry.list.first, @registry.get('ruby-leopard-1.8.6')
  end

  test "should return runtime based on index" do
    @registry.add(RubyConfig::Runtimes::LeopardRuntime)
    
    assert_equal @registry.list.first, @registry.get(1)
  end

  test "should return return true if runtime exists" do
    @registry.add(RubyConfig::Runtimes::LeopardRuntime)
    
    assert @registry.exists?('ruby-leopard-1.8.6')
  end
  
end


