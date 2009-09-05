module RubyConfig
  
  module Runtimes
  
    class RubyEnterpriseEditionRuntime < RubyConfig::RuntimeBase
  
      VERSION = '1.8.6'
      HANDLE = "ruby-enterprise-#{VERSION}"
      TIMESTAMP = '20090421'
      DESCRIPTION = "Ruby Enterprise Edition #{VERSION}-#{TIMESTAMP}"
      RUBY_ENTERPRISE_EDITION_DIR = "ruby-enterprise-#{VERSION}-#{TIMESTAMP}"
      RUBY_ENTERPRISE_EDITION_ARCHIVE = "#{RUBY_ENTERPRISE_EDITION_DIR}.tar.gz"
      RUBY_ENTERPRISE_EDITION_DOWNLOAD_URL = "http://rubyforge.org/frs/download.php/55511/#{RUBY_ENTERPRISE_EDITION_ARCHIVE}"
    
      def handle
        HANDLE
      end

      def description
        DESCRIPTION
      end
  
      def archive_file_name
        RUBY_ENTERPRISE_EDITION_ARCHIVE
      end

      def archive_download_url
        RUBY_ENTERPRISE_EDITION_DOWNLOAD_URL
      end
      
      def install
        extract_tar_gz(File.join(@tmp_path, archive_file_name), @tmp_path)
        
        ree_installer
      end
      
      private
        def ree_installer
          puts "path= #{File.join(@tmp_path, RUBY_ENTERPRISE_EDITION_DIR)}"
          puts File.exists?(File.join(@tmp_path, RUBY_ENTERPRISE_EDITION_DIR))
          FileUtils.cd(File.join(@tmp_path, RUBY_ENTERPRISE_EDITION_DIR))
          system("./installer -a #{@install_path}/ruby --dont-install-useful-gems")
        end
  
    end
  
  end
end