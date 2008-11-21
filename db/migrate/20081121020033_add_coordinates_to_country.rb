class AddCoordinatesToCountry < ActiveRecord::Migration
  def self.up
    add_column :countries, :x_position, :integer
    add_column :countries, :y_position, :integer
  end

  def self.down
    remove_column :countries, :x_position
    remove_column :countries, :y_position
  end
end
