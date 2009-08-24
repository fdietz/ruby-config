require 'rubygems'
require 'test/unit'
require 'mocha'

dir = File.dirname(__FILE__)
Dir.glob(File.join(File.dirname(__FILE__), '../lib/ruby_config/**/*.rb')).each {|f| require f }

require 'fileutils'
require 'open-uri'
require 'tempfile'
require 'pathname'
require 'ostruct'
require 'optparse'
require "yaml"

class Test::Unit::TestCase  
  # test "verify something" do
  #   ...
  # end
  def self.test(name, &block)
    test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
    defined = instance_method(test_name) rescue false
    raise "#{test_name} is already defined in #{self}" if defined
    if block_given?
      define_method(test_name, &block)
    else
      define_method(test_name) do
        flunk "No implementation provided for #{name}"
      end
    end
  end
  
end
