# -*- encoding: utf-8 -*-
# stub: actionpack-xml_parser 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "actionpack-xml_parser"
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Prem Sichanugrist"]
  s.date = "2015-04-17"
  s.email = "s@sikac.hu"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://www.rubyonrails.org"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.2.5"
  s.summary = "XML parameters parser for Action Pack (removed from core in Rails 4.0)"

  s.installed_by_version = "2.2.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, ["< 5", ">= 4.0.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<actionpack>, ["< 5", ">= 4.0.0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<actionpack>, ["< 5", ">= 4.0.0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
