module RubyConfig
  class FileHelper
        
    class << self
      def write_content_to_file(content, path)
        File.open(path, 'w') { |file| file.write content }
      end
      
      def append_content_to_file(content, path)
        File.open(path, 'a') { |file| file.write content }
      end
    
      def read_content_from_file(path)
        File.open(path, "r")  { |file| file.read  }
      end
      
      def store_yml(path, data)
        File.open(path, 'w') { |out| YAML.dump( data, out ) }
      end
    
      def load_yml(path)
        File.open(path) { |yf| YAML::load( yf ) }
      end
    
      def delete_file(path)
        File.delete(path) if File.exist?(path)
      end
            
      def set_symlink(target_path, symlink_path)
        FileUtils.ln_s(target_path, symlink_path)
      end
      
    end
    
  end
end