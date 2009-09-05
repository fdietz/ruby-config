require File.join(File.dirname(__FILE__), '..', 'test_helper')
#require 'ruby_config/profile_config'

class ProfileConfigTest < Test::Unit::TestCase
  
  def setup
    @file = File.join('/', 'tmp', 'bash_profile') 
    @config = RubyConfig::ProfileConfig.new(@file)
  end
  
  def teardown
    FileUtils.rm(@file) if File.exist?(@file)
  end
  
  test "should return true if file exists" do
    File.open(@file, 'w') { |file| file.write "blabla" }
    assert @config.file_exists?
  end
  
  test "should return false if file does NOT exist" do
    assert_equal false, @config.file_exists?
  end

  test "should return false if configuration does NOT exist" do
    File.open(@file, 'w') { |file| file.write "blabla" }
    assert_equal false, @config.exists?
  end
  
  test "should return true if configuration exists" do
    @config.create_new_file
    assert @config.exists?
  end
  
  test "should create new bash_profile file" do
    @config.create_new_file
    
    content = File.open(@file, "r")  { |file| file.read  }
    assert content.include?("ruby-config")
  end
  
  test "should apply changes to existing bash_profile file" do
    File.open(@file, 'w') { |file| file.write "#!bin/bash\n" }
    @config.apply_changes
    
    content = File.open(@file, "r")  { |file| file.read  }
    assert content.include?("ruby-config")
  end
  
  test "should contain the RUBY_HOME variable" do
    result = @config.send(:export_variables_string)
    assert result.include?("RUBY_HOME=$HOME/.ruby-config/ruby")
  end
  
  test "should contain the GEM_HOME variable" do
    result = @config.send(:export_variables_string)
    assert result.include?("GEM_HOME=$HOME/.ruby-config/gem")
  end
  
  test "should contain the GEM_PATH variable" do
    result = @config.send(:export_variables_string)
    assert result.include?("GEM_PATH=$HOME/.ruby-config/gem")
  end
  
  test "should contain the PATH variable" do
    result = @config.send(:export_variables_string)
    assert result.include?("PATH=$RUBY_HOME/bin:$GEM_HOME/bin:$PATH")
  end
  
  test "should contain the ruby-config header" do
    result = @config.send(:content_for_existing_script)
    assert result.include?("# ruby-config v#{RubyConfig::VERSION}")
  end
  
  test "should contain bash script header" do
    result = @config.send(:content_for_new_script)
    assert result.include?("#!/bin/bash")
  end
  
end
