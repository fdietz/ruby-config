require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ruby-config"
    gem.summary = %Q{Install and Switch between various Ruby Runtimes easily}
    gem.description = %Q{ruby-config lets one easily install and switch between various Ruby Runtimes}
    gem.email = "fdietz@gmail.com"
    gem.homepage = "http://github.com/fdietz/ruby-config"
    gem.authors = ["Frederik Dietz"]
    gem.files = FileList['lib/**/*.rb', 'bin/*', 'VERSION', 'ReleaseNotes.md', 'README.md']
    gem.test_files = FileList['test/unit/**/*_test.rb']
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  #test.libs << 'lib' #<< 'test'
  test.pattern = 'test/unit/**/*_test.rb'
  test.verbose = true
end

Rake::TestTask.new(:integration) do |test|
  #test.libs << 'lib' #<< 'test'
  test.pattern = 'test/integration/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/unit/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "test #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
