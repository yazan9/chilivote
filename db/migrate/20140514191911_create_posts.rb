class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :votes
      t.string :image_id  

      t.timestamps
    end
  end
end
