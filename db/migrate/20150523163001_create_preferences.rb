class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :user_id
      t.integer :contribution_id
      t.boolean :hide
      t.boolean :inappropriate

      t.timestamps
    end
  end
end
