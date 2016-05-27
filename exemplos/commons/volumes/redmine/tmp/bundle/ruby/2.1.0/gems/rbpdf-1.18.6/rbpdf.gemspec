# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbpdf/version'

Gem::Specification.new do |spec|
  spec.name          = "rbpdf"
  spec.version       = Rbpdf::VERSION
  spec.authors       = ["NAITOH Jun"]
  spec.email         = ["naitoh@gmail.com"]
  spec.summary       = %q{RBPDF via TCPDF.}
  spec.description   = %q{A template plugin allowing the inclusion of ERB-enabled RBPDF template files.}
  spec.homepage      = ""
  spec.license       = "LGPL 2.1 or later"
  spec.files         = Dir.glob("lib/rbpdf/version.rb") +
                       Dir.glob("lib/*.rb") +
                       Dir.glob("lib/core/rmagick.rb") +
                       Dir.glob("lib/fonts/*.{rb,z}") +
                       Dir.glob("lib/fonts/freefont-*/*") +
                       Dir.glob("lib/fonts/dejavu-fonts-ttf-*/{AUTHORS,BUGS,LICENSE,NEWS,README}") +
                       Dir.glob("test/*") +
                       ["Rakefile", "rbpdf.gemspec", "Gemfile",
                        "CHANGELOG", "test_unicode.rbpdf", "README.md", "LICENSE.TXT",
                        "utf8test.txt", "logo_example.png" ]
  spec.rdoc_options  += [ '--exclude', 'lib/fonts/',
                          '--exclude', 'lib/htmlcolors.rb',
                          '--exclude', 'lib/unicode_data.rb' ]

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
