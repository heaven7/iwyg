# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "devise"
  s.version = "1.1.rc0"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jos\303\251 Valim", "Carlos Ant\303\264nio"]
  s.date = "2010-04-03"
  s.description = "Flexible authentication solution for Rails with Warden"
  s.email = "contact@plataformatec.com.br"
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "MIT-LICENSE", "README.rdoc", "TODO"]
  s.files = ["CHANGELOG.rdoc", "MIT-LICENSE", "README.rdoc", "TODO"]
  s.homepage = "http://github.com/plataformatec/devise"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Flexible authentication solution for Rails with Warden"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<warden>, ["~> 0.10.3"])
    else
      s.add_dependency(%q<warden>, ["~> 0.10.3"])
    end
  else
    s.add_dependency(%q<warden>, ["~> 0.10.3"])
  end
end
