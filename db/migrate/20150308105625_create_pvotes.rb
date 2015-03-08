class CreatePvotes < ActiveRecord::Migration
  def change
    create_table :pvotes do |t|
      t.references :user, index: true
      t.references :vote_option, index: true
      t.references :poll, index: true

      t.timestamps
    end
  end
end
