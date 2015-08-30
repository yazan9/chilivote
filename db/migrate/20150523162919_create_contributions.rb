class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :user_id
      t.string :title
      t.text :body
      t.integer :contribution_type
      t.string :image_id
      t.integer :parent_id
      t.integer :privacy

      t.timestamps
    end
  end
end
