require File.join(File.dirname(__FILE__), 'ruby_from_source_helper')

module RubyConfig
  
  module Runtimes
    
    
    class Ruby187Runtime < RubyConfig::RuntimeBase      
      MAJOR_VERSION = '1.8'
      MINOR_VERSION = '7'
      PATCH_LEVEL = '174'
      
      VERSION_STRING = RubyConfig::Runtimes::RubyFromSourceHelper.ruby_version(MAJOR_VERSION, MINOR_VERSION, PATCH_LEVEL)
      HANDLE = "ruby-#{VERSION_STRING}"
      DESCRIPTION = "Ruby #{VERSION_STRING}"
      ARCHIVE_PATH = "ruby-#{VERSION_STRING}"
      
      def handle
        HANDLE
      end

      def description
        DESCRIPTION
      end
  
      def archive_file_name
        "ruby-#{VERSION_STRING}.tar.gz"
      end

      def archive_download_url
        RubyConfig::Runtimes::RubyFromSourceHelper.download_url(MAJOR_VERSION, MINOR_VERSION, PATCH_LEVEL)
      end
      
      def install
        extract_tar_gz(File.join(@tmp_path, archive_file_name), @tmp_path)
        
        RubyConfig::Runtimes::RubyFromSourceHelper.compile(File.join(@tmp_path, ARCHIVE_PATH), ruby_home_path)
      end
        
    end
  
  end
end