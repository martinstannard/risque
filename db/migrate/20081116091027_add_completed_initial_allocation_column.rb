class AddCompletedInitialAllocationColumn < ActiveRecord::Migration
  def self.up
    add_column :game_players, :completed_initial_allocation, :integer,:size => 1, :default => 0
  end

  def self.down
    remove_column :game_players, :completed_initial_allocation
  end
end
