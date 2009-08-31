require 'rubygems'
require 'fileutils'
require 'open-uri'
require 'tempfile'
require 'pathname'
require 'ostruct'
require 'optparse'
require 'yaml'
require 'highline/import'

require 'ruby_config/runner'
#require 'ruby_config/registry'

module RubyConfig  
  def self.version
    version_path = File.join(File.dirname(__FILE__), '..', 'VERSION')
    File.open(version_path, "r")  { |file| file.read  }
  end
end

