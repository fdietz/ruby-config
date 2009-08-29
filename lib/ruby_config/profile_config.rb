# Not used currently
module RubyConfig
  class ProfileConfig 
        
    def initialize(bash_profile_path)
      @bash_profile_path = bash_profile_path
    end
    
    def change
      RubyConfig::FileHelper.append_content_to_file(content_with_header, @bash_profile_path)
    end
    
    def exists?
      RubyConfig::FileHelper.read_content_from_file(@bash_profile_path).include?(content)
    end

    def content_with_header
      str = header
      str << content
      str
    end
    
    def content
      str = ""
      [ruby_home, gem_home, gem_path, path].each do |line|
        str << export_line(line)
      end
      str
    end
    
    private 
    
    def header
      "# ruby-config v#{RubyConfig.version}"
    end
    
    def ruby_home
      "RUBY_HOME=#{home}/#{ruby_config}/ruby"
    end
    
    def gem_home
      "GEM_HOME=#{home}/#{ruby_config}/gem"
    end
    
    def gem_path
      "GEM_PATH=#{home}/#{ruby_config}/gem"
    end
    
    def path
      "PATH=$RUBY_HOME/bin:$GEM_HOME/bin:$PATH"
    end
    
    def home
      "$HOME"
    end
    
    def ruby_config
      ".ruby-config"
    end
    
    def export_line(str)
      "export #{str}\n"
    end
  end
end