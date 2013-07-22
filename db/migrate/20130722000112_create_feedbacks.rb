class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :rating
      t.string :message

      t.timestamps
    end
  end
end
