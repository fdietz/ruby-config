module RubyConfig
  
  class Registry

    attr_reader :ruby_config_path
    
    def initialize(ruby_config_path)
      @ruby_config_path = ruby_config_path
      @runtime_install_path = File.join(ruby_config_path, "runtimes")
      @tmp_path = File.join(ruby_config_path, "tmp")
      
      @config = RubyConfig::Config.new(@ruby_config_path)
      @environment_config = RubyConfig::EnvironmentConfig.new(@ruby_config_path)
      
      @list = []
      ensure_config_directory_exists
    end

    def add(runtime_const)
      @list << runtime_const.new(@runtime_install_path, @tmp_path)
    end
    
    def default?(handle)
      handle == default_handle
    end
        
    def first
      @list.first
    end
    
    def exist?(handle)
      !!get(handle)
    end
    
    def get(handle)
      handle_int = handle.to_i # returns 0 if no fixnum
      if handle_int > 0 && handle_int << @list.size
        @list.values_at(handle_int-1).first
      else
        @list.find { |item| item.handle == handle  }
      end
    end 
    
    def list_available
      @list
    end

    def list_installed
      @list.find_all { |item| item.already_installed?}
    end
        
    def install(runtime)      
      runtime.do_install unless runtime.already_installed?
      
      use(runtime)
      
      runtime.do_post_install
      
      runtime      
    end
        
    def use(runtime)    
      set_default_handle(runtime.handle)
      @config.save
      
      set_symlinks_to_runtime(runtime)
      
      runtime      
    end

    private
    
    def set_symlinks_to_runtime(runtime)
      ruby_path = File.join(@ruby_config_path, "ruby")
      gem_path = File.join(@ruby_config_path, "gem")
      RubyConfig::FileHelper.delete_file(ruby_path)
      RubyConfig::FileHelper.delete_file(gem_path)
      RubyConfig::FileHelper.set_symlink(runtime.ruby_home_path, ruby_path)
      RubyConfig::FileHelper.set_symlink(runtime.gem_home_path, gem_path)
    end
        
    def default_handle
      @config.get("default")
    end
    
    def set_default_handle(default_handle)
      @config.set("default", default_handle)
    end
    
    def ensure_config_directory_exists
      FileUtils.mkdir_p(@ruby_config_path)
      FileUtils.mkdir_p(@tmp_path)      
      FileUtils.mkdir_p(@runtime_install_path)
    end

    # bash_alias required by jruby nailgun
    # def update_current_environment_config(ruby_home, gem_home, bash_alias = {})
    #   set_bash_var = {'GEM_HOME' => gem_home, 'RUBY_HOME' => ruby_home}
    #   prepend_bash_var = {'PATH' => "#{ruby_home}/bin" }
    #   
    #   @environment_config.set_bash_var = set_bash_var
    #   @environment_config.prepend_bash_var = prepend_bash_var
    #   @environment_config.bash_alias = bash_alias
    #   @environment_config.save
    # end

  end
  
end
