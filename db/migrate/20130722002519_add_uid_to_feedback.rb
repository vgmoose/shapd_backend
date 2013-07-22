class AddUidToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :user_id, :int
  end
end
