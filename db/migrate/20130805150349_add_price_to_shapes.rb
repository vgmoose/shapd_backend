class AddPriceToShapes < ActiveRecord::Migration
  def change
    add_column :shapes, :price, :float
  end
end
