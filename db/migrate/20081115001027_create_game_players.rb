class CreateGamePlayers < ActiveRecord::Migration
  def self.up
    create_table :game_players do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :armies_to_allocate, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :game_players
  end
end
