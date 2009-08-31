require 'ruby_config/rubygems'

module RubyConfig

  class Installer
    
    RUBY_CONFIG_GEM_NAME = 'fdietz-ruby-config'
    
    attr_reader :rubygems
    
    def initialize(ruby_config_path)
      @ruby_config_path = ruby_config_path
      @rubygems = RubyConfig::Rubygems.new(ruby_config_path)
      
      ensure_config_directory_exists
    end

    def install(runtime)       
      runtime.do_install 

      # TOOD: only cleanup runtime-specific files
      cleanup_tmp_dir
    end
    
    def post_install(runtime)
      @rubygems.install(runtime) unless @rubygems.installed?(runtime)
    
      runtime.post_install
    
      # install thyself
      @rubygems.gem_install(RUBY_CONFIG_GEM_NAME)
    end

    def runtime_install_path
      File.join(@ruby_config_path, 'runtimes')
    end

    def tmp_path
      File.join(@ruby_config_path, 'tmp')
    end
    
    private

      def cleanup_tmp_dir
        empty_dir(tmp_path)
      end
      
      def empty_dir(path)
        Dir[File.join(path, '*')].each do |file|
          FileUtils.remove_entry_secure(file) if Pathname.new(file).directory?
        end
      end      
            
      def ensure_config_directory_exists
        FileUtils.mkdir_p(@ruby_config_path)
        FileUtils.mkdir_p(tmp_path)      
        FileUtils.mkdir_p(runtime_install_path)
      end
   
  end
end