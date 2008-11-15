class AddWorldIdToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :world_id, :integer
  end

  def self.down
    remove_column :games, :world_id
  end
end
