class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :title
      t.integer :contribution_id
      t.string :image_id
      t.boolean :correct_answer

      t.timestamps
    end
  end
end
