class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :target_id
      t.integer :user_id
      t.integer :like_type
      t.integer :group_id

      t.timestamps
    end
  end
end
