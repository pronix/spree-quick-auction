class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.timestamps
      
      t.integer :product_id, :null => false
      t.integer :price, :null => false, :default => 0
      t.boolean :sold, :null => false, :default => false
    end
  end

  def self.down
    drop_table :prices
  end
end
