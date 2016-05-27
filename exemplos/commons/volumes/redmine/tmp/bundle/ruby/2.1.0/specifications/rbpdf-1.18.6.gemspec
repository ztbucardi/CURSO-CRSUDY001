# -*- encoding: utf-8 -*-
# stub: rbpdf 1.18.6 ruby lib

Gem::Specification.new do |s|
  s.name = "rbpdf"
  s.version = "1.18.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["NAITOH Jun"]
  s.date = "2015-06-20"
  s.description = "A template plugin allowing the inclusion of ERB-enabled RBPDF template files."
  s.email = ["naitoh@gmail.com"]
  s.homepage = ""
  s.licenses = ["LGPL 2.1 or later"]
  s.rdoc_options = ["--exclude", "lib/fonts/", "--exclude", "lib/htmlcolors.rb", "--exclude", "lib/unicode_data.rb"]
  s.rubygems_version = "2.2.5"
  s.summary = "RBPDF via TCPDF."

  s.installed_by_version = "2.2.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.6"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.6"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.6"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
