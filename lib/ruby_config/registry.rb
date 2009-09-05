require 'ruby_config/config'
require 'ruby_config/runtime_base'

Dir.glob(File.join(File.dirname(__FILE__), 'runtimes/*.rb')).each {|f| require f }

module RubyConfig
  
  class Registry

    attr_reader :ruby_config_path
    
    def initialize(ruby_config_path)
      @ruby_config_path = ruby_config_path
      load_available_runtimes.each { |runtime| add(runtime) }
    end
    
    def list
      @list ||= []
    end
    
    def add(runtime_const)
      list << runtime_const.new(runtime_install_path, tmp_path)
    end
                
    def exists?(handle)
      !!get(handle)
    end
    
    def get(handle)
      handle_int = handle.to_i # returns 0 if no fixnum
      if handle_int > 0 && handle_int << list.size
        list.values_at(handle_int-1).first
      else
        list.find { |item| item.handle == handle  }
      end
    end 
    
    def list_available
      list
    end

    def list_installed
      list.find_all { |item| item.already_installed?}
    end
                
    private

      def load_available_runtimes
        [ RubyConfig::Runtimes::LeopardRuntime, RubyConfig::Runtimes::RubyEnterpriseEditionRuntime,
          RubyConfig::Runtimes::JRubyRuntime, RubyConfig::Runtimes::Ruby19Runtime,
          RubyConfig::Runtimes::Ruby186Runtime, RubyConfig::Runtimes::Ruby187Runtime 
        ]
      end
        
      def runtime_install_path
        File.join(@ruby_config_path, 'runtimes')
      end
    
      def tmp_path
        File.join(@ruby_config_path, 'tmp')
      end
      
  end
end
