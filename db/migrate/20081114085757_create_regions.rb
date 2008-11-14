class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.integer :world_id
      t.string :name
      t.integer :bonus

      t.timestamps
    end
  end

  def self.down
    drop_table :regions
  end
end
