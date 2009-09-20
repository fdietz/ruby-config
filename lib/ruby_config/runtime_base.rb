module RubyConfig

  class RuntimeBase
  
    attr_reader :install_path, :tmp_path
    
    def initialize(install_path, tmp_path)
      @install_path = File.join(install_path, handle)
      @tmp_path = tmp_path
    end
  
    def do_install
      prepare_install
      install
    end

    # called after the archive was successfully downloaded to tmp/archive_file_name directory
    # you might want to:
    # * extract archive
    # * configure && make && make install
    def install
      raise "Not implemented yet!"
    end
    
    # called after:
    # * runtime.install
    # * switch to newly installed runtime
    # * rubygems installation
    #
    # you might want to:
    # * install additional rubygems
    # * set symlinks
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

    # optional 
    # Array of gem names of type string
    def runtime_specific_gems
      []
    end
    
    # example: 1.8 or 1.9
    def major_version
      '1.8'
    end

    # hash (key: alias name, value: alias bash script)
    # def bash_alias;{};end
    
    def ruby_home_path
      File.join(@install_path, 'ruby')
    end
    
    def ruby_bin_path
      File.join(ruby_home_path, 'bin')
    end
    
    def gem_home_path
      File.join(@install_path, 'gem')
    end
    
    def gem_bin_path
      File.join(gem_home_path, 'bin')
    end
    
    def ruby_executable_path
      File.join(ruby_bin_path, 'ruby')
    end

    def gem_executable_path
      puts "entering RuntimeBase::#{gem_executable_path}.."
      File.join(ruby_bin_path, 'gem')
    end
    
    def irb_executable_path
      File.join(ruby_bin_path, 'irb')
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

    def create_directory_structure
      [@install_path, @tmp_path, ruby_home_path, ruby_bin_path, gem_home_path].each do |path|
        FileUtils.mkdir_p(path)
      end
    end      
    
    def archive_path
      File.join(@tmp_path, archive_file_name)
    end
    
    def prepare_install
      create_directory_structure                  
      download_archive unless archive_exists?  
    end
    
    def rubygems_installed?
      File.exists?(gem_executable_path)      
    end
        
    private 
    
      def archive_exists?
        File.exist?(archive_path)
      end

      def download_archive
        download_file(archive_download_url, archive_path)
      end
        
      def download_file(url, destination_path)
        system("wget #{url} --output-document=#{destination_path}")
      end  
     
      def extract_tar_gz(archive_path, destination_path)
        system("tar xfvz #{archive_path} -C #{destination_path}")
      end    
     
  end

end
