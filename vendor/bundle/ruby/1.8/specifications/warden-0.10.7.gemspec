# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "warden"
  s.version = "0.10.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Neighman"]
  s.date = "2010-05-30"
  s.email = "has.sox@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.textile"]
  s.files = ["LICENSE", "README.textile"]
  s.homepage = "http://github.com/hassox/warden"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "warden"
  s.rubygems_version = "1.8.11"
  s.summary = "Rack middleware that provides authentication for rack applications"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 1.0.0"])
    else
      s.add_dependency(%q<rack>, [">= 1.0.0"])
      s.add_dependency(%q<rspec>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.0.0"])
    s.add_dependency(%q<rspec>, [">= 1.0.0"])
  end
end
