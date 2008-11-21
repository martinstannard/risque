class Colour < ActiveRecord::Migration
  def self.up
    create_table :colours do |t|
      t.string :name
      t.string :hex

      t.timestamps
    end
  end

  def self.down
    drop_table :colours
  end
end
