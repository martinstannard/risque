class AddColourToRegion < ActiveRecord::Migration
  def self.up
    add_column :regions, :colour, :string, :default => ''
  end

  def self.down
    remove_column :regions, :colour
  end

end
