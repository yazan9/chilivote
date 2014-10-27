class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :notification_type
      t.integer :user_me
      t.integer :user_friend
      t.integer :target_id

      t.timestamps
    end
  end
end
