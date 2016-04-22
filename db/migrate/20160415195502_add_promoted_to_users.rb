class AddPromotedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :promoted, :boolean, default: false
  end
end
