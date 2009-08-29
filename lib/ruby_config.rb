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
require 'ruby_config/registry'
require 'ruby_config/file_helper'

module RubyConfig  
  def self.version
    RubyConfig::FileHelper.read_content_from_file(File.join(File.dirname(__FILE__), '..', 'VERSION'))
  end
end

