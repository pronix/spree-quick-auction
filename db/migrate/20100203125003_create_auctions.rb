class CreateAuctions < ActiveRecord::Migration
  def self.up
    add_column :products, :step, :integer, :null => false, :default => 0
    add_column :products, :available_off, :datetime
  end

  def self.down
    remove_column :products, :available_off
    remove_column :products, :step
  end
end
