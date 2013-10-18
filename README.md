# Welcome to the IWYG Project

[![Codeship](https://www.codeship.io/projects/d3525ac0-1812-0131-6024-0ef248b6a1b0/status)](https://www.iwyg.net)

iwyg is a social exchange system built in rails. this system can be seen on [www.iwyg.net](https://www.iwyg.net)


## Installation

Just clone and bundle:

  `git clone https://github.com/heaven7/iwyg`
  
  `cd iwyg`
  
  `bundle install`

## Configuration

Rename or copy the *.sample.yml files in the config directory and change them to your needs:

	database.sample.yml => database.yml

	email.sample.yml => email.yml

	settings.sample.yml => settings.yml

After this you can build up the database and migrate to it:
  
  `rake db:create`
  
  `rake db:migrate`

 
