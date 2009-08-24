module RubyConfig

  class Runner

    RUBY_CONFIG_PATH = File.join(ENV['HOME'], ".ruby-config")
    
    def initialize
      @registry = RubyConfig::Registry.new(RUBY_CONFIG_PATH)
      load_available_runtimes.each { |runtime| @registry.add(runtime) }
    end
    
    def run
      options_parser = RubyConfig::OptionsParser.new
      
      begin
        options = options_parser.parse

        if options.list_available
          list_available  
        elsif options.list_installed
          list_installed
        elsif options.install
          install_runtime(options.runtime)
        elsif options.uninstall
          # TODO
        elsif options.use
          use_runtime(options.runtime)
        elsif options.help
          help(options_parser)
        end
      rescue OptionParser::ParseError => e
        puts e
        options_parser.print_help
      end
    end

    private 
    
    def load_available_runtimes
      list = []
      list << RubyConfig::Runtimes::LeopardRuntime
      list << RubyConfig::Runtimes::RubyEnterpriseEditionRuntime
      list << RubyConfig::Runtimes::JRubyRuntime
      list << RubyConfig::Runtimes::Ruby19Runtime
      list << RubyConfig::Runtimes::Ruby186Runtime
      list << RubyConfig::Runtimes::Ruby187Runtime
      list
    end
    
    def help(options_parser)
      print_info_header
      options_parser.print_help
    end
    
    def install_runtime(handle)
      unless @registry.exist?(handle)
        puts "Unknown ruby runtime: #{handle}"
        return
      end
      
      runtime = @registry.get(handle)
            
      puts "#{runtime} already installed" if runtime.already_installed?
      
      @registry.install(runtime)
      print_use_results(runtime)
    end
    
    def use_runtime(handle)
      unless @registry.exist?(handle)
        puts "Unknown ruby runtime: #{handle}"
        return
      end
      
      runtime = @registry.get(handle)
      
      if @registry.use(runtime)
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
      print @registry.default?(item.handle) ? "*" : " "
      puts " #{item}"
    end
    
    def print_use_results(runtime)
      puts "env:"
      puts " RUBY_HOME=#{runtime.ruby_home_path}"
      puts " GEM_HOME=#{runtime.gem_home_path}"
      
      unless runtime.bash_alias.empty?
        puts "\nalias:"
        print_alias(runtime.bash_alias)
      end
      
      puts "\nruby -v:"
      display_system_ruby_version
    end
    
    def print_alias(hash)
      hash.each do |key, value|
        puts " alias #{key}=\"#{value}\""
      end
    end
    
    def display_ruby_version(runtime)
      puts "Running: #{runtime}"
    end
    
    def display_system_ruby_version
      system "ruby -v"
    end
    
    def abort(message)
      puts message
      exit
    end

  end
end

#RubyConfig::Runner.new.run


# require 'fileutils'
# if ARGV.include?('--dry-run')
#   include FileUtils::DryRun
# else
#   include FileUtils::Verbose
# end