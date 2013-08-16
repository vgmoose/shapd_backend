class AddOreoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oreo, :string
  end
end
