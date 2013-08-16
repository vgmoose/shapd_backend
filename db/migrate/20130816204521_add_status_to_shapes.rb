class AddStatusToShapes < ActiveRecord::Migration
  def change
    add_column :shapes, :status, :string
  end
end
