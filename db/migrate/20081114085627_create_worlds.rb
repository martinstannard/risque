class CreateWorlds < ActiveRecord::Migration
  def self.up
    create_table :worlds do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :worlds
  end
end
