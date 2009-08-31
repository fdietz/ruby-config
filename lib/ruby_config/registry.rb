require 'ruby_config/config'

module RubyConfig
  
  class Registry

    attr_reader :ruby_config_path
    
    def initialize(ruby_config_path)
      @ruby_config_path = ruby_config_path
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

      def runtime_install_path
        File.join(@ruby_config_path, 'runtimes')
      end
    
      def tmp_path
        File.join(@ruby_config_path, 'tmp')
      end
  end
  
end
