require 'rubygems'
require 'fileutils'
require 'open-uri'
require 'tempfile'
require 'pathname'
require 'ostruct'
require 'optparse'
require 'yaml'
require 'highline/import'

require 'ruby_config/main'

module RubyConfig  
  VERSION = File.open(File.join(File.dirname(__FILE__), '..', 'VERSION'), "r")  { |file| file.read  }  
end

