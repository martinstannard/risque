class AddArmiesToCountry < ActiveRecord::Migration
  def self.up
    add_column :countries, :armies, :integer, :default => 0
    add_column :countries, :game_player_id, :integer
   end


  def self.down
    remove_column :countries, :armies
    remove_column :countries, :game_player_id
  end
end
