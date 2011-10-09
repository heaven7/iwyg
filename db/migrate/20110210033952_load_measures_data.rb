require 'active_record/fixtures'
class LoadMeasuresData < ActiveRecord::Migration
  def self.up
    down
    directory = File.join(File.dirname(__FILE__), "data")
    Fixtures.create_fixtures(directory, "measures")
  end

  def self.down
    Measure.delete_all
  end
end
