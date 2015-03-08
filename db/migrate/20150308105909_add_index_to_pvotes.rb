class AddIndexToPvotes < ActiveRecord::Migration
  def change
    add_index :pvotes, [:vote_option_id, :user_id], unique: true
  end
end
