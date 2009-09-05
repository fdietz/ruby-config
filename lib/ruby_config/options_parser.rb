module RubyConfig
  class OptionsParser

    COMMANDS = { 
      'list' => 'List installed Ruby runtimes',
      'available' => 'List available Ruby runtimes',
      'switch' => 'Switch to specific Ruby runtime',
      'install' => 'Install specific Ruby runtime',
      'uninstall' => 'Uninstall specific Ruby runtime',
      'setup' => 'Setup your bash environment'
    }
    
    OPTIONS = {
      '-v, --version' => "Display version",
      '-h, --help' => "Display this screen"
    }
    
    EXAMPLES = [
      'ruby-config list ',
      'ruby-config install jruby-1.3.1',
      'ruby-config switch jruby-1.3.1',
      'ruby-config -v'
    ]
       
    def initialize
      create_options
    end
    
    def print_help
      puts "Usage: ruby-config [command] [options]"
      puts
      puts " Available Commands:"
      
      COMMANDS.each do |key, value|
        puts "  #{key} #{indent} #{value}"
      end
      
      puts
      puts " Available Options:"
      OPTIONS.each do |key, value|
        puts "  #{key} #{indent} #{value}"
      end
      
      puts 
      puts " Examples:"
      EXAMPLES.each do |value|
        puts "  #{value}"
      end
      
      puts
    end
        
    def parse_commands!(arguments)
      args = find_commands(arguments)
      
      @commands = OpenStruct.new
      @commands.list = false
      @commands.available = false
      @commands.switch = false
      @commands.install = false
      @commands.uninstall = false
      @commands.setup = false
     
      case args.first
      when 'list'
        @commands.list = true
      when 'available'
        @commands.available = true
      when 'setup'
        @commands.setup = true
      when 'install'
        @commands.install = true
        @commands.handle = args[1]
        abort("No Runtime specified") unless @commands.handle
      when 'uninstall'
        @commands.uninstall = true
        @commands.handle = args[1]
        abort("No Runtime specified") unless @commands.handle
      when 'switch'
        @commands.switch = true
        @commands.handle = args[1]
        abort("No Runtime specified") unless @commands.handle
      end
      
      @commands
    end
            
    def parse_options!(arguments)
      @optparse.parse!(arguments)
      @options
    end

    private
    
      def create_options
        @options = OpenStruct.new
        @options.help = false

        @optparse = OptionParser.new do |opts|
          opts.on('-v', '--version', 'Display version' ) do
            puts "ruby-config version: #{RubyConfig::VERSION}"
            exit
          end
          opts.on('-h', '--help', 'Display this screen' ) do
            @options.help = true
          end
        end
      end
      
      def find_commands(args)
        args.reject { |a| a =~ /^(-|--)/ }
      end
      
      def indent
        "\t\t\t\t"
      end
    
  end
  
end
