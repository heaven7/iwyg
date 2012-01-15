namespace :db do
  desc "Erase and fill test-database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    # Faker::Config.locale = :de
    [User, Userdetails, Location, Item, Ping, Group].each(&:delete_all)

    User.populate 10 do |user|
      user.login    = Populator.words(1)
      user.email   = Faker::Internet.email
      
      Userdetails.populate 1 do |userdetails|
        userdetails.user_id = user.id
        userdetails.firstname  = Faker::Name.name
        userdetails.lastname  = Faker::Name.name
        userdetails.birthdate = 70.years.ago...Time.now
        userdetails.created_at  = 2.years.ago...Time.now
      end

      Location.populate 1 do |location|
        location.address = Faker::Address.street_address
        location.city    = Faker::Address.city
        location.country = Faker::Address.country
        location.zip     = Faker::Address.zip_code
        location.locatable_type = "User"
        location.locatable_id = user.id
        location.user_id = user.id
      end

      Group.populate 1 do |group|
        group.user_id = user.id
        group.title = Populator.words(1..3)
        group.description = Populator.sentences(1..3)
        group.created_at  = 2.years.ago...Time.now
      end

      Item.populate 10 do |item|
        item.user_id = user.id
        item.title = Populator.words(1..5).titleize
        item.description = Populator.paragraphs(1..3)
        item.item_type_id = 1..6
        item.multiple = [0, 1]
        item.need = [0, 1]
        item.status = 1..4
        item.amount = 1..100
        item.measure_id = 1..7
      end
    end # end user

    Ping.populate 100 do |ping|
      ping.user_id = 1..10
      ping.status = 1..4
      ping.body = Populator.sentences(1..3)
      ping.pingable_type = "Item"
      ping.pingable_id = 1..100
      ping.created_at = 2.years.ago...Time.now
    end

  end # endtask
end # end namespae