module RubyConfig
  module Runtimes
    class LeopardRuntime < RubyConfig::RuntimeBase
    
      def handle
        'ruby-leopard-1.8.6'
      end

      def description
        'Default Leopard Ruby 1.8.6'
      end
    
      def archive_file_name
        ""
      end

      def archive_download_url
        ""
      end
      
      def install
        # intenionally left empty, since ruby is installed by default on OS X
      end
      
      def already_installed?
        true
      end
      
      # "/System/Library/Frameworks/Ruby.framework/Versions/Current/usr"
      def ruby_home_path
        File.join("/System", "Library", "Frameworks", "Ruby.framework", "Versions", "Current", "usr")
      end
      
      # $ ruby -r rubygems -e "p Gem.path"
      # ["/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8", "/Library/Ruby/Gems/1.8"]
      
      # /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/lib/ruby/gems/1.8
      # /Library/Ruby/Gems/1.8
      def gem_home_path
        File.join(ruby_home_path, "lib", "ruby", "gems", "1.8")
      end
    
    end
  
  end
end