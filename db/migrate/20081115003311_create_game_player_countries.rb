class CreateGamePlayerCountries < ActiveRecord::Migration
  def self.up
    create_table :game_player_countries do |t|
      t.integer :game_player_id
      t.integer :country_id
      t.integer :armies, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :game_player_countries
  end
end
