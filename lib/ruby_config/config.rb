module RubyConfig
  class Config 
    
    attr_accessor :hash
    
    #DEFAULTS = { 'default' => 'ruby-leopard-1.8.6' }
    
    def initialize(path)
      @config_file = File.join(path, "config.yml")
      File.exist?(@config_file) ? load : @hash = {}#.merge(DEFAULTS)      
    end

    def default_handle
      get('default')
    end
    
    def default_handle=(handle)
      set('default', handle)
    end
    
    def get(key)
      @hash[key] 
    end
    
    def set(key, value)
      @hash[key] = value
    end
        
    def save
      File.open(@config_file, 'w') { |out| YAML.dump( @hash, out ) }
    end
    
    def load
      @hash = File.open(@config_file) { |yf| YAML::load( yf ) }
    end
        
    def to_hash
      @hash
    end
  end
end