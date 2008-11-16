class AddPlayersGame < ActiveRecord::Migration
  def self.up
    add_column :games, :player_list, :string
  end

  def self.down
    remove_column :games, :player_list
  end
end
