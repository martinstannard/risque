class AddShapeToRegion < ActiveRecord::Migration
  def self.up
    add_column :regions, :shape, :string, :length => 30
  end

  def self.down
    add_column :regions, :shape
  end
end
