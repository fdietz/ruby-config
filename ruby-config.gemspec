# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-config}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Frederik Dietz"]
  s.date = %q{2009-08-29}
  s.default_executable = %q{ruby-config}
  s.description = %q{ruby-config lets one easily install and switch between various Ruby Runtimes}
  s.email = %q{fdietz@gmail.com}
  s.executables = ["ruby-config"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "bin/ruby-config",
     "lib/ruby_config.rb",
     "lib/ruby_config/config.rb",
     "lib/ruby_config/file_helper.rb",
     "lib/ruby_config/options_parser.rb",
     "lib/ruby_config/profile_config.rb",
     "lib/ruby_config/registry.rb",
     "lib/ruby_config/runner.rb",
     "lib/ruby_config/runtime_base.rb",
     "lib/ruby_config/runtimes/jruby_runtime.rb",
     "lib/ruby_config/runtimes/leopard_runtime.rb",
     "lib/ruby_config/runtimes/ruby186_runtime.rb",
     "lib/ruby_config/runtimes/ruby187_runtime.rb",
     "lib/ruby_config/runtimes/ruby19_runtime.rb",
     "lib/ruby_config/runtimes/ruby_enterprise_edition_runtime.rb",
     "lib/ruby_config/runtimes/ruby_from_source_helper.rb"
  ]
  s.homepage = %q{http://github.com/fdietz/ruby-config}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Install and Switch between various Ruby Runtimes easily}
  s.test_files = [
    "test/unit/profile_config_test.rb",
     "test/unit/registry_test.rb",
     "test/unit/runtime_base_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
