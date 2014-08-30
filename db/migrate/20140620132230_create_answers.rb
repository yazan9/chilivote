class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :name
      t.integer :cvote_id
      t.string :image_id
      t.integer :likes
      t.timestamps
    end
  end
end
