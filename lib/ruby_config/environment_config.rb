# Not used currently
module RubyConfig
  class EnvironmentConfig 
    
    attr_writer :set_bash_var, :prepend_bash_var, :append_bash_var, :bash_alias
    
    def initialize(path)
      @config_file = File.join(path, "current_env_config")
    end
        
    def save
      configuration = create_configuration(@set_bash_var, @prepend_bash_var, @append_bash_var, @bash_alias)
      RubyConfig::FileHelper.write_content_to_file(configuration, @config_file)  
    end

    private

      def create_configuration(set_bash_var = {}, prepend_bash_var = {}, append_bash_var = {}, bash_alias = {})
        configuration = ""
        prepend_bash_var.each { |key,value| configuration << prepend_to_bash_environment_var(key, value) + "\n" }
        set_bash_var.each { |key,value| configuration << set_bash_environment_var(key, value) + "\n" }
        bash_alias.each { |key, value| configuration << set_bash_alias(key, value) + "\n"  }
        configuration
      end
      
      def prepend_to_bash_environment_var(var, path)
        "export #{var}=#{path}:$#{var}"
      end
    
      def append_to_bash_environment_var(var, path)
        "export #{var}=$#{var}:#{path}"
      end
    
      def set_bash_environment_var(var, path)
        "export #{var}=#{path}"
      end
    
      def set_bash_alias(var, script)
        "alias #{var}=\"#{script}\""
      end
    
  end
end