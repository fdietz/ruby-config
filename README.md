# Ruby-Config

Ruby-Config lets you install and switch between various Ruby Runtimes

Currently, it supports the following Ruby Runtimes:

* Ruby 1.9.1-p243
* Ruby 1.8.6-p383
* Ruby 1.8.7-p174
* Ruby Enterprise Edition 1.8.6-20090421
* JRuby 1.3.1

Ruby-Config is written in Ruby and designed to be unobtrusive to your system configuration.
It sets up all runtimes and a dedicated gem home for each runtime in the user's 
home directory. 

## Getting Started

Install the gem:

	sudo gem install fdietz-ruby-config
	
Ensure that your bash profile script is configured correctly:

	#bash: ruby-config --setup
	
Note, that the setup routine will show the changes it will make beforehand and will prompt you
before actually applying the changes. You can manually apply the changes if you decide.

List all available runtimes:

	#bash: ruby-config -a
	

List all currently installed runtimes:

	#bash: ruby-config -l

	Installed Ruby Versions:
	1)   Default Leopard Ruby 1.8.6 [ruby-leopard-1.8.6]
	2)   Ruby Enterprise Edition 1.8.6-20090421 [ruby-enterprise-1.8.6]
	3)   JRuby 1.3.1 [jruby-1.3.1]
	4)   Ruby 1.9.1-p243 [ruby-1.9.1-p243]
	5) * Ruby 1.8.6-p383 [ruby-1.8.6-p383]
	6)   Ruby 1.8.7-p174 [ruby-1.8.7-p174]

The wildcard for the 5. item indicates that this is the currently used runtime.
	
Install new Runtime by handle name:

	#bash: ruby-config -i jruby-1.3.1
	
Alternatively, you can use the index of the available runtimes listing:

	#bash: ruby-config -i 3

Switch to an already installed runtime:

	#bash: ruby-config -u jruby-1.3.1
	
Alternatively, you can use the index again.

	#bash: ruby-config -u 3

## Prerequisites

### Mac OS X: 
You need to install [Xcode](http://developer.apple.com/technology/Xcode.html)

### Ubuntu Linux:
Use apt-get to install the essential packages:

	sudo apt-get install build-essential zlib1g-dev libreadline5-dev libssl-dev

### JRuby:

You need a complete Java installation.

#### OS X: 
OS X comes with an already installed Java version.

#### Ubuntu Linux:
Use apt-get to install the essential packages:

 	sudo apt-get install sun-java6-jre sun-java6-jdk


## Kudos

Thanks to Relevance for their work on [Ruby Switcher](http://github.com/relevance/etc/blob/3d607c8ac2f76077f27c3cbc0140b04a89f546be/bash/ruby_switcher.sh) which I used as the basis for the installation of various Ruby Runtimes.

## Contact
* Author: Frederik Dietz <fdietz@gmail.com>
* Website: [http://fdietz.net](http://fdietz.net) 
* Github: [http://github.com/fdietz/ruby-config](http://github.com/fdietz/ruby-config)


## License

(The MIT License)

Copyright (c) 2009 Frederik Dietz <fdietz@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
