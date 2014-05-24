class AddGlobalIndexToVotes < ActiveRecord::Migration
  def change
    add_index :votes, [:user_id, :post_id], unique: true
  end
end
