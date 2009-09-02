module RubyConfig

  class Rubygems

    VERSION = "1.3.5"
    ARCHIVE_NAME = "rubygems-#{VERSION}"
    ARCHIVE_FILE_NAME = "#{ARCHIVE_NAME}.tgz"
    DOWNLOAD_URL = "http://rubyforge.org/frs/download.php/60718/#{ARCHIVE_FILE_NAME}"
        
    def initialize(ruby_config_path)
      @ruby_config_path = ruby_config_path
    end
    
    def install(runtime)
      download_file(DOWNLOAD_URL, archive_file_name) unless archive_exists?

      extract_tar_gz(archive_file_name, tmp_path)
      
      ruby_gems_setup(archive_path, runtime.ruby_executable_path, runtime.additional_library_path)
    end
    
    def gem_install(gem_technical_name)
      gem_executable_path = File.join(@ruby_config_path, 'gem')
      system "GEM_HOME=#{gem_executable_path} gem install -q --no-ri --no-rdoc #{gem_technical_name}"
    end 

    private 
      
      # system("ruby setup.rb --prefix=#{additional_library_path}")
      def ruby_gems_setup(path, ruby_executable_path, additional_library_path)
        FileUtils.cd(path)
        puts "ruby executable path: #{ruby_executable_path}"
        system("#{ruby_executable_path} setup.rb  --prefix=#{additional_library_path}")
      end
      
      def extract_tar_gz(tgz_archive_path, destination_path)
        system("tar xfvz #{tgz_archive_path} -C #{destination_path}")
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
     
      def download_file(url, destination_path)
        system("wget #{url} --output-document=#{destination_path}")
      end
    
  end
end