class AddColourToGamePlayer < ActiveRecord::Migration
  def self.up
    add_column :game_players, :colour, :string, :length => 20
  end

  def self.down
    remove_column :game_players, :colour
  end

end
