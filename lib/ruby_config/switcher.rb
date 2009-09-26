module RubyConfig

  class Switcher
    
    attr_reader :config
    
    def initialize(ruby_config_path)
      @ruby_config_path = ruby_config_path
      @config = RubyConfig::Config.new(@ruby_config_path)
    end
    
    def switch(runtime)    
      set_default_handle(runtime.handle)
      set_symlinks_to_runtime(runtime)
    end
    
    def set_symlinks_to_runtime(runtime)
      delete_existing_symlinks
      create_symlinks(runtime)
      set_environment(runtime)
    end
    
    private
    
      # will only apply for current ruby-config process
      # after ruby-config exits bash profile will take over again
      def set_environment(runtime)
        ENV['RUBY_HOME'] = runtime.ruby_home_path
        ENV['GEM_HOME'] = runtime.gem_home_path
        #ENV['GEM_PATH'] = runtime.gem_home_path
        ENV['PATH'] = "#{runtime.ruby_bin_path}:#{runtime.gem_bin_path}:#{ENV['PATH']}"
      end
      
      def ruby_path
        File.join(@ruby_config_path, "ruby")
      end
      
      def gem_path
        File.join(@ruby_config_path, "gem")
      end

      def create_symlinks(runtime)
        FileUtils.ln_s(runtime.ruby_home_path, ruby_path)
        FileUtils.ln_s(runtime.gem_home_path, gem_path)
      end
      
      def delete_existing_symlinks
        [ruby_path, gem_path].each do |path|
          File.delete(path) if File.exist?(path)
        end
      end
                 
      def set_default_handle(handle)
        @config.default_handle = handle
        @config.save
      end
  end
end