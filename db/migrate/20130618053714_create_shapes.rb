class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.string :name
      t.string :shape
      t.integer :user_id
      t.integer :public

      t.timestamps
    end
  end
end
