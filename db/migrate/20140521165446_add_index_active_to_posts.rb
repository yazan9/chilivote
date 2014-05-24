class AddIndexActiveToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :active
  end
end
