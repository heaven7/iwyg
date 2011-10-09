# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{routing-filter}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sven Fuchs"]
  s.date = %q{2011-01-25}
  s.description = %q{Routing filters wraps around the complex beast that the Rails routing system is, allowing for unseen flexibility and power in Rails URL recognition and generation.}
  s.email = %q{svenfuchs@artweb-design.de}
  s.homepage = %q{http://github.com/svenfuchs/routing-filter}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{[none]}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Routing filters wraps around the complex beast that the Rails routing system is, allowing for unseen flexibility and power in Rails URL recognition and generation}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, [">= 0"])
      s.add_development_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 0"])
      s.add_development_dependency(%q<test_declarative>, [">= 0"])
    else
      s.add_dependency(%q<actionpack>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<test_declarative>, [">= 0"])
    end
  else
    s.add_dependency(%q<actionpack>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<test_declarative>, [">= 0"])
  end
end
