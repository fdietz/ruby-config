module RubyConfig
  class Config 
    
    attr_accessor :hash
    
    DEFAULTS = {'default' => 'ruby-leopard-1.8.6'}
    
    def initialize(path)
      @config_file = File.join(path, "config.yml")
      File.exist?(@config_file) ? load : @hash = {}.merge(DEFAULTS)      

      #puts "config: #{@hash.inspect}"
    end

    def get(key)
      @hash[key] 
    end
    
    def set(key, value)
      @hash[key] = value
    end
        
    def save
      RubyConfig::FileHelper.store_yml(@config_file, @hash)
    end
    
    def load
      @hash = RubyConfig::FileHelper.load_yml(@config_file)
    end
        
    def to_hash
      @hash
    end
  end
end