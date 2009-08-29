module RubyConfig

  class RuntimeBase
  
    attr_reader :install_path, :tmp_path
    
    def initialize(install_path, tmp_path)
      @install_path = File.join(install_path, handle)
      @tmp_path = tmp_path
    end
    
    def do_install
      create_directory_structure
      
      download_file_unless_exists(archive_file_name, archive_download_url)
      
      # runtime specific installation part
      install
          
      cleanup_tmp_dir
    end
        
    def install
      raise "Not implemented yet!"
    end

    def do_post_install
      post_install
      
      install_rubygems unless File.exists?(gem_executable_path)
      
      # install thyselve
      #install_gem('ruby-config')
    end
    
    # called after install and runtime is enabled
    def post_install
    end
    
    # name of ruby runtime archive
    def archive_file_name
      raise "Not implemented yet!"
    end
    
    # download url of ruby runtime
    def archive_download_url
      raise "Not implemented yet!"
    end
    
    # technical name used to select runtime
    def handle
      raise "Not implemented yet!"
    end

    def description
      raise "Not implemented yet!"
    end

    # example: 1.8 or 1.9
    def major_version
      '1.8'
    end

    # hash (key: alias name, value: alias bash script)
    def bash_alias;{};end
    
    def ruby_home_path
      File.join(@install_path, 'ruby')
    end
    
    def ruby_bin_path
      File.join(ruby_home_path, 'bin')
    end
    
    def gem_home_path
      File.join(@install_path, 'gem')
    end
    
    def ruby_executable_path
      File.join(ruby_bin_path, 'ruby')
    end

    def gem_executable_path
      File.join(ruby_bin_path, 'gem')
    end
    
    # aka site_ruby
    def additional_library_path
      File.join(ruby_home_path, 'lib', 'ruby', 'site_ruby', major_version)
    end
    
    def default_library_path
      File.join(ruby_home_path, 'lib', 'ruby', major_version)
    end
    
    def to_s
      "#{description} [#{handle}]"
    end

    def already_installed?
       Pathname.new(File.join(ruby_bin_path, 'ruby')).exist?
    end
    
    def delete
      FileUtils.remove_entry_secure(@install_path)
    end
    
    protected

      def install_rubygems
        version = "1.3.5"
        archive_name = "rubygems-#{version}"
        archive_file_name = "#{archive_name}.tgz"
        download_url = "http://rubyforge.org/frs/download.php/60718/#{archive_file_name}"
        
        download_file_unless_exists(archive_file_name, download_url)
        
        extract_tar_gz(File.join(@tmp_path, archive_file_name), @tmp_path)
        FileUtils.cd(File.join(@tmp_path, archive_name))
        #system("ruby setup.rb --prefix=#{additional_library_path}")
        system("ruby setup.rb")
      end
      
      def cleanup_tmp_dir
        empty_dir(@tmp_path)
      end
      
      def create_directory_structure
        FileUtils.mkdir_p(@install_path)
        FileUtils.mkdir_p(@tmp_path)
        FileUtils.mkdir_p(ruby_home_path)
        FileUtils.mkdir_p(ruby_bin_path)
        FileUtils.mkdir_p(gem_home_path)
      end      
      
      def download_file_unless_exists(archive, url)
        archive_path = File.join(@tmp_path, archive)
        unless File.exist?(archive_path)
          path = download_file_wget(url, archive_path)
          puts "#{archive} downloaded successfully to #{archive_path}"
        end
      end
       
     def download_file_wget(url, destination_path)
       system("wget #{url} --output-document=#{destination_path}")
     end

     def extract_tar_gz(archive_path, destination_path)
       system("tar xfvz #{archive_path} -C #{destination_path}")
     end
      
     def empty_dir(path)
       Dir[File.join(path, '*')].each do |file|
         FileUtils.remove_entry_secure(file) if Pathname.new(file).directory?
       end
     end
     
     def gem_install(gem_technical_name)
       system "gem install -q --no-ri --no-rdoc #{gem_technical_name}"
     end
  end

  end
