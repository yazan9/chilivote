class CreateCvotes < ActiveRecord::Migration
  def change
    create_table :cvotes do |t|
      t.string :name
      t.integer :user_id
      t.datetime :expiry_date
      t.timestamps
    end
  end
end
