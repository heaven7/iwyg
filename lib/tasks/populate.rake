namespace :db do
  desc "Erase and fill test-database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    # Faker::Config.locale = :de
    # Tag = ActsAsTaggableOn::Tag
    Tag = ActsAsTaggableOn::Tag
    Tagging = ActsAsTaggableOn::Tagging
    [User, Userdetails, Location, Item, Ping, Group, Tag, Tagging, ItemAttachment].each(&:delete_all)

    User.populate 10 do |user|
      user.login    = Faker::Name.first_name
      user.email   = Faker::Internet.email
      
      Userdetails.populate 1 do |userdetails|
        userdetails.user_id = user.id
        userdetails.firstname  = Faker::Name.first_name
        userdetails.lastname  = Faker::Name.last_name
        userdetails.birthdate = 70.years.ago...Time.now
        userdetails.created_at  = 2.years.ago...Time.now
      end

      Location.populate 1 do |location|
        location.address = Faker::Address.street_address
        location.city    = Faker::Address.city
        location.country = Faker::Address.country
        location.zip     = Faker::Address.zip_code
        location.lat     = Faker::Address.latitude
        location.lng     = Faker::Address.longitude
        location.gmaps   = true
        location.locatable_type = "User"
        location.locatable_id = user.id
        location.user_id = user.id
      end

      # users interests
      Tag.populate 1 do |tag|
        tag.name = Populator.words(1)
        tagging = Tagging.new
        tagging.tag_id = Random.new.rand(1..30)
        tagging.taggable_type = "User"
        tagging.taggable_id = user.id
        tagging.context = 'interests'
        tagging.save
      end

      # users wishes
      Tag.populate 1 do |tag|
        tag.name = Populator.words(1)
        tagging = Tagging.new
        tagging.tag_id = Random.new.rand(1..30)
        tagging.taggable_type = "User"
        tagging.taggable_id = user.id
        tagging.context = 'wishs'
        tagging.save
      end

      # users aims
      Tag.populate 1 do |tag|
        tag.name = Populator.words(1)
        tagging = Tagging.new
        tagging.tag_id = Random.new.rand(1..30)
        tagging.taggable_type = "User"
        tagging.taggable_id = user.id
        tagging.context = 'aims'
        tagging.save
      end

      Item.populate 10 do |item|
        item.user_id = user.id
        item.title = Populator.words(1..5).titleize
        item.description = Populator.paragraphs(1..3)
        item.item_type_id = 1..6
        item.multiple = [0, 1]
        item.from = 2.years.ago...Time.now
        item.till = Time.now...2.years.since
        item.need = [0, 1]
        item.status = 1..4
        item.amount = 1..100
        item.measure_id = 1..7

        Tag.populate 1 do |tag|
          tag.name = Populator.words(1)
          tagging = Tagging.new
          tagging.tag_id = Random.new.rand(1..30)
          tagging.taggable_type = "Item"
          tagging.taggable_id = item.id
          tagging.context = 'tags'
          tagging.save
        end

        Location.populate 1 do |location|
          location.address = Faker::Address.street_address
          location.city    = Faker::Address.city
          location.country = Faker::Address.country
          location.zip     = Faker::Address.zip_code
          location.lat     = Faker::Address.latitude
          location.lng     = Faker::Address.longitude
          location.gmaps   = true
          location.locatable_type = "Item"
          location.locatable_id = item.id
          location.user_id = user.id
        end

        ItemAttachment.populate 1..5 do |item_attachment|
          item_attachment.item_id = item.id
          item_attachment.attachment_id = 1..100
        end
        
      end # item end

      Group.populate 1 do |group|
        group.user_id = user.id
        group.title = Populator.words(1..3)
        group.description = Populator.sentences(1..3)
        group.created_at  = 2.years.ago...Time.now

        Location.populate 1 do |location|
          location.address = Faker::Address.street_address
          location.city    = Faker::Address.city
          location.country = Faker::Address.country
          location.zip     = Faker::Address.zip_code
          location.lat     = Faker::Address.latitude
          location.lng     = Faker::Address.longitude
          location.gmaps   = true
          location.locatable_type = "Group"
          location.locatable_id = group.id
          location.user_id = user.id
        end

        Tag.populate 1 do |tag|
          tag.name = Populator.words(1)
          tagging = Tagging.new
          tagging.tag_id = Random.new.rand(1..10)
          tagging.taggable_type = "Group"
          tagging.taggable_id = group.id
          tagging.context = 'tags'
          tagging.save
        end

        ItemAttachment.populate 1..5 do |item_attachment|
          item_attachment.group_id = group.id
          item_attachment.attachment_id = 1..100
        end

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