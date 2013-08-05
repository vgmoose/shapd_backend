class AddProductIdToShapes < ActiveRecord::Migration
  def change
    add_column :shapes, :product_id, :int
  end
end
