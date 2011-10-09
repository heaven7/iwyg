# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cldwalker-hirb"
  s.version = "0.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gabriel Horner"]
  s.date = "2009-09-17"
  s.description = "Hirb currently provides a mini view framework for console applications, designed to improve irb's default output.  Hirb improves console output by providing a smart pager and auto-formatting output. The smart pager detects when an output exceeds a screenful and thus only pages output as needed. Auto-formatting adds a view to an output's class. This is helpful in separating views from content (MVC anyone?). The framework encourages reusing views by letting you package them in classes and associate them with any number of output classes."
  s.email = "gabriel.horner@gmail.com"
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  s.files = ["LICENSE.txt", "README.rdoc"]
  s.homepage = "http://tagaholic.me/hirb/"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "tagaholic"
  s.rubygems_version = "1.8.11"
  s.summary = "A mini view framework for console/irb that's easy to use, even while under its influence."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
