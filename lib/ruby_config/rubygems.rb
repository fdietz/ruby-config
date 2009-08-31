module RubyConfig

  class Rubygems

    VERSION = "1.3.5"
    ARCHIVE_NAME = "rubygems-#{VERSION}"
    ARCHIVE_FILE_NAME = "#{ARCHIVE_NAME}.tgz"
    DOWNLOAD_URL = "http://rubyforge.org/frs/download.php/60718/#{ARCHIVE_FILE_NAME}"
        
    def initialize(ruby_config_path)
      @ruby_config_path = ruby_config_path
    end

    def installed?(runtime)
      File.exists?(runtime.gem_executable_path)      
    end
    
    def install(runtime)
      download_file_unless_exists(DOWNLOAD_URL, ARCHIVE_FILE_NAME) unless archive_exists?

      extract_tar_gz(archive_file_name, tmp_path)
      
      ruby_gems_setup(archive_path)
    end
    
    def gem_install(gem_technical_name)
      system "gem install -q --no-ri --no-rdoc #{gem_technical_name}"
    end 

    private 
      
      # system("ruby setup.rb --prefix=#{additional_library_path}")
      def ruby_gems_setup(path)
        FileUtils.cd(path)
        system("ruby setup.rb")
      end
      
      def extract_tar_gz(archive_path, destination_path)
        system("tar xfvz #{archive_path} -C #{destination_path}")
      end    
    
      def tmp_path
        File.join(@ruby_config_path, 'tmp')
      end
    
      def archive_file_name
        File.join(tmp_path, ARCHIVE_FILE_NAME)
      end
      
      def archive_path
        File.join(tmp_path, ARCHIVE_NAME)
      end
    
      def archive_exists?
        File.exist?(archive_path)
      end
    
      def download_file_unless_exists(archive, url)        
        download_file(url, archive_path(archive)) unless archive_exists?(archive)
      end
    
      def download_file(url, destination_path)
        system("wget #{url} --output-document=#{destination_path}")
      end
    
  end
end