class ChangeColourOfRegionAndPlayer < ActiveRecord::Migration
  def self.up
    add_column :game_players, :colour_id, :integer
    add_column :regions, :shape_id, :integer
  end

  def self.down
    remove_column :game_players, :colour_id
    remove_column :regions, :shape_id
  end
end
