
module RubyConfig
  
  module Runtimes
  
    class JRubyRuntime < RubyConfig::RuntimeBase
  
      VERSION = '1.3.1'
      JRUBY_DIR = "jruby-#{VERSION}"
      JRUBY_ARCHIVE = "jruby-bin-#{VERSION}.tar.gz"
      JRUBY_DOWNLOAD_URL = "http://dist.codehaus.org/jruby/#{VERSION}/#{JRUBY_ARCHIVE}"
      
      def handle
        "jruby-#{VERSION}"
      end

      def description
        "JRuby #{VERSION}"
      end
  
      def archive_file_name
        JRUBY_ARCHIVE
      end

      def archive_download_url
        JRUBY_DOWNLOAD_URL
      end
          
      # only required for nailgun support
      # def bash_alias
      #   {'ruby_ng', 'jruby --ng', 
      #    'ruby_ng_server', 'jruby --ng-server'}
      # end
      
      def install  
        extract_tar_gz(File.join(@tmp_path, archive_file_name), @tmp_path)
        
        copy_archive_content_to_ruby_directory
        
        set_symlinks_for_jruby_commands
        chmod_executables
      end

      def post_install
        # install_nailgun
        install_jruby_specific_gem
      end
  
      private
      
      def copy_archive_content_to_ruby_directory
        files = Dir.glob(File.join(@tmp_path, JRUBY_DIR, '*'))
        FileUtils.cp_r(files, ruby_home_path)
      end
            
      # there is already a jgem and gem, therefore no symlink required for gem!
      def set_symlinks_for_jruby_commands
        jruby_commands_requiring_symlinks.each do |item|
          FileUtils.ln_s(item.first, bin_path(item.last))
        end
      end
      
      def jruby_commands_requiring_symlinks
        [[bin_path('jruby'), 'ruby' ], 
         [bin_path('jirb') , 'irb'  ]]
      end
      
      # CHECK: can we download an archive which preserves permissions instead?
      def chmod_executables
        %w(jruby jgem gem jirb).each { |command| chmod_executable_for_others(bin_path(command)) }  
      end

      def chmod_executable_for_others(path)
        FileUtils.chmod(0755, path)
      end
      
      def bin_path(command)
        File.join(ruby_bin_path, command)
      end
      
      # TODO: "make" does not work correctly
      def install_nailgun
        nailgun_path = File.join(ruby_home_path, 'tool', 'nailgun')
        puts "nailgun_path: #{nailgun_path}"
        FileUtils.cd(nailgun_path)
        system "#{nailgun_path}/make"
      end
      
      def install_jruby_specific_gem
        gem_install("rake")
        gem_install("jruby-openssl")
      end
      
    end
  
  end
end