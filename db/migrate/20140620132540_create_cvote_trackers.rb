class CreateCvoteTrackers < ActiveRecord::Migration
  def change
    create_table :cvote_trackers do |t|
      t.integer :user_id
      t.integer :cvote_id
      t.integer :answer_id
      t.timestamps
    end
  end
end
