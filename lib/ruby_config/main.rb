require 'ruby_config/registry'
require 'ruby_config/runtime_base'
require 'ruby_config/options_parser'
require 'ruby_config/profile_config'
require 'ruby_config/installer'
require 'ruby_config/switcher'

module RubyConfig

  class Main

    RUBY_CONFIG_PATH = File.join(ENV['HOME'], ".ruby-config")
    
    def initialize
      @rubygems = RubyConfig::Rubygems.new(RUBY_CONFIG_PATH)
      @registry = RubyConfig::Registry.new(RUBY_CONFIG_PATH)      
      @installer = RubyConfig::Installer.new(RUBY_CONFIG_PATH)
      @switcher = RubyConfig::Switcher.new(RUBY_CONFIG_PATH)
      @config = RubyConfig::Config.new(RUBY_CONFIG_PATH)
    end
    
    def main(argv)
      arguments = argv
      options_parser = RubyConfig::OptionsParser.new
            
      begin
        options = options_parser.parse_options!(arguments)
        
        if options.help
          help(options_parser)
          exit
        end
      rescue OptionParser::ParseError => e
        puts e
        options_parser.print_help
        exit
      end
      
      commands = options_parser.parse_commands!(arguments)
      
      if commands.list
        list_installed
      elsif commands.available
        list_available
      elsif commands.install
        install(commands.handle)
      elsif commands.uninstall
        uninstall(commands.handle)
      elsif commands.switch
        switch(commands.handle)
      elsif commands.setup
        setup
      else
        puts "Unknown Command: #{arguments}"
        options_parser.print_help
      end
      
    end

    private 
    
    def setup
      config = RubyConfig::ProfileConfig.new(bash_profile_path)
      if config.file_exists? && config.exists?
        puts "Found existing profile configuration. You are all set!"
      else
        show_configuration_changes(config.export_variables_string)
        if agree("Apply configuration changes? [y/n]  ", true)
          config.file_exists? ? config.apply_changes : config.create_new_file
          educate_about_source_profile
        end
      end
    end

    def educate_about_source_profile
      puts
      puts "Done! Either start a new shell or execute the following command to apply the changes to your current shell:"
      puts "# source #{bash_profile_path}"
    end
    
    def show_configuration_changes(content)
      puts "Ruby-Config will apply the following changes to your profile"
      puts "#{bash_profile_path}:"
      puts content
      puts
    end
    
    def bash_profile_path
      File.join(ENV['HOME'], '.bash_profile')
    end
    
    def uninstall(handle)
      unless @registry.exists?(handle)
        puts "Unknown ruby runtime: #{handle}."
        return
      end
            
      if default?(handle)
        puts "Can't delete currently selected runtime."
        return
      end
      
      runtime = @registry.get(handle)
      
      if agree("Really want to delete: #{runtime.description}? [y/n]  ", true)
        runtime.delete
        puts "Done!"
      end
    end
        
    def help(options_parser)
      print_info_header
      options_parser.print_help
    end
    
    def install(handle)
      unless @registry.exists?(handle)
        puts "Unknown ruby runtime: #{handle}"
        return
      end
      
      runtime = @registry.get(handle)
            
      if runtime.already_installed?
        puts "#{runtime} already installed" 
      else
        @installer.install(runtime)
        @switcher.switch(runtime)
        @installer.post_install(runtime)
        
        print_use_results(runtime)
      end
      
    end
    
    def switch(handle)
      unless @registry.exists?(handle)
        puts "Unknown ruby runtime: #{handle}"
        return
      end
      
      runtime = @registry.get(handle)
      
      if @switcher.switch(runtime)
        #display_ruby_version
        #print_use_results(runtime)
        display_ruby_version(runtime)
      else
        puts "Unknown Ruby Runtime: #{handle}"
        puts 
        list_installed
        puts
        puts example_use_usage
      end
    end  
    
    def example_use_usage
      puts "Example usage: ruby-config -u #{@registry.first.handle}"
    end
    
    def print_info_header
      puts "ruby-config (http://github/fdietz/ruby-config)"
      puts "Author: Frederik Dietz <fdietz@gmail.com>"
      puts "Version: #{RubyConfig::VERSION}"
      puts
    end
    
    def list_available
      puts "Available Ruby Versions:\n"
      @registry.list_available.each_with_index do |item, index|
        print_runtime(index, item)      
      end  
    end
    
    def list_installed
      puts "Installed Ruby Versions:\n"
      @registry.list_installed.each_with_index do |item, index|
        print_runtime(index, item)
      end      
    end
    
    def print_runtime(index, item)
      print "#{index+1}) "
      print default?(item.handle) ? "*" : " "
      puts " #{item}"
    end
    
    def print_use_results(runtime)
      puts "gem env:"
      display_gem_env(runtime)
      
      puts "\nruby -v:"
      display_ruby_version(runtime)
    end
        
    def display_gem_env(runtime)
      system("#{runtime.gem_executable_path} env")
    end
    
    def display_ruby_version(runtime)
      system("#{runtime.ruby_executable_path} -v")    
    end
        
    def abort(message)
      puts message
      exit
    end

    def default?(handle)
      handle == @config.default_handle
    end
    
  end
end