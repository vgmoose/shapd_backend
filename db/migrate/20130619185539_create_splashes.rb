class CreateSplashes < ActiveRecord::Migration
  def change
    create_table :splashes do |t|
      t.string :email

      t.timestamps
    end
  end
end
