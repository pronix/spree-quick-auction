class CreateProductSizes < ActiveRecord::Migration
  def self.up
    create_table :product_sizes do |t|
      t.integer :product_id, :null => false
      t.string :size, :null => false, :default => 'm'

      t.timestamps
    end
  end

  def self.down
    drop_table :product_sizes
  end
end
