module RubyConfig

  class ProfileConfig 
        
    def initialize(bash_profile_path)
      @bash_profile_path = bash_profile_path
    end
    
    def apply_changes
      File.open(@bash_profile_path, 'a') { |file| file.write content_for_existing_script }
    end
    
    def exists?
      File.open(@bash_profile_path, "r")  { |file| file.read  }.include?(export_variables_string)
    end

    def file_exists?
      File.exists?(@bash_profile_path)
    end
    
    def create_new_file
      File.open(@bash_profile_path, 'w') { |file| file.write content_for_new_script }
    end
    
    def export_variables_string
      str = ""
      [ruby_home, gem_home, gem_path, path].each do |line|
        str << export_line(line)
      end
      str
    end
    
    private 
    
    def content_for_new_script
      str = bash_header
      str << "\n"
      str << header
      str << export_variables_string
    end
    
    def content_for_existing_script
      str = "\n"
      str = header
      str << export_variables_string
      str
    end
        
    def bash_header
      "#!/bin/bash"
    end
    
    def header
      "# ruby-config v#{RubyConfig::VERSION}"
    end
    
    def ruby_home
      "RUBY_HOME=#{ruby_config_path}/ruby"
    end
    
    def gem_home
      "GEM_HOME=#{ruby_config_path}/gem"
    end
    
    def gem_path
      "GEM_PATH=#{ruby_config_path}/gem"
    end
    
    def path
      "PATH=$RUBY_HOME/bin:$GEM_HOME/bin:$PATH"
    end

    def ruby_config_path
      "$HOME/.ruby-config"
    end
    
    def export_line(str)
      "export #{str}\n"
    end
  end
end