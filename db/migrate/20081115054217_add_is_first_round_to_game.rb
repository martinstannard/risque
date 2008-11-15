class AddIsFirstRoundToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :is_allocation_round, :integer,:size => 1, :default => 1
  end

  def self.down
    remove_column :games, :is_allocation_round
  end
end
