class Create4Players < ActiveRecord::Migration
  def self.up
    1.upto(4) do |i|
      Player.create :name => "Player #{i}"
    end
  end

  def self.down
  end
end
