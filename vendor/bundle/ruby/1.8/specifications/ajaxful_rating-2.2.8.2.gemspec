# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ajaxful_rating"
  s.version = "2.2.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Edgar J. Suarez"]
  s.date = "2010-08-27"
  s.description = "Provides a simple way to add rating functionality to your application."
  s.email = "edgar.js@gmail.com"
  s.extra_rdoc_files = ["CHANGELOG", "README.textile", "lib/ajaxful_rating.rb", "lib/axr/css_builder.rb", "lib/axr/errors.rb", "lib/axr/helpers.rb", "lib/axr/locale.rb", "lib/axr/model.rb", "lib/axr/stars_builder.rb"]
  s.files = ["CHANGELOG", "README.textile", "lib/ajaxful_rating.rb", "lib/axr/css_builder.rb", "lib/axr/errors.rb", "lib/axr/helpers.rb", "lib/axr/locale.rb", "lib/axr/model.rb", "lib/axr/stars_builder.rb"]
  s.homepage = "http://github.com/edgarjs/ajaxful-rating"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ajaxful_rating", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ajaxful_rating"
  s.rubygems_version = "1.8.11"
  s.summary = "Provides a simple way to add rating functionality to your application."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
