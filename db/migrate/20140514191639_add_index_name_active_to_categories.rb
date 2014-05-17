class AddIndexNameActiveToCategories < ActiveRecord::Migration
  def change
    add_index :categories, :name, unique: true
    add_index :categories, :active
  end
end
