class CreateNeighbours < ActiveRecord::Migration
  def self.up
    create_table :neighbours do |t|
      t.integer :country_id
      t.integer :neighbour_id

      t.timestamps
    end
  end

  def self.down
    drop_table :neighbours
  end
end
