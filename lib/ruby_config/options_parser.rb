module RubyConfig
  class OptionsParser
    
    def initialize
      create_options
    end
    
    def print_help
      puts @optparse
    end
    
    def create_options
      @options = OpenStruct.new
      @options.verbose = false
      @options.list_available = false
      @options.list_installed = false
      @options.use = false
      @options.runtime = nil
      @options.install = false
      @options.help = false
      
      @optparse = OptionParser.new do |opts|
        opts.banner = "Usage: ruby-config [options]"

        opts.on('-a', '--list-available', 'List available Ruby runtimes') do
          @options.list_available = true
        end

        opts.on('-l', '--list-installed', 'List installed Ruby runtimes') do
          @options.list_installed = true
        end

        opts.on('-u', '--use [HANDLE]', 'Use specific Ruby runtime') do |runtime|
          @options.use = true
          @options.runtime = runtime        
          abort("No Runtime specified") unless runtime
        end

        opts.on('-i', '--install [HANDLE]', 'Install specific Ruby runtime') do |runtime|
          @options.install = true
          @options.runtime = runtime
          abort("No Runtime specified") unless runtime
        end

        opts.on('--uninstall [HANDLE]', 'Uninstall specific Ruby runtime') do |runtime|
          @options.uninstall = true
          @options.runtime = runtime
          abort("No Runtime specified") unless runtime
        end

        opts.on('-v', '--version', 'Display version' ) do
          puts "ruby-config version: #{RubyConfig.VERSION}"
          exit
        end

        opts.on('-h', '--help', 'Display this screen' ) do
          @options.help = true
        end
      end
      
    end
    
    def parse
      @optparse.parse!
      @options
    end
      
  end
  
end
