module RubyConfig
  module Runtimes
    
    module RubyFromSourceHelper
      
      def self.download_url(major_version, minor_version, patch_level)
        version = ruby_version(major_version, minor_version, patch_level)
        "ftp://ftp.ruby-lang.org/pub/ruby/#{major_version}/ruby-#{version}.tar.gz"
      end
    
      def self.ruby_version(major_version, minor_version, patch_level)
        "#{major_version}.#{minor_version}-p#{patch_level}"
      end
    
      def self.compile(source_path, installation_path)
        FileUtils.cd(source_path)
        system("./configure --prefix=#{installation_path} --enable-shared")
        system("make")
        system("make install")
      end
    end
    
  end
end