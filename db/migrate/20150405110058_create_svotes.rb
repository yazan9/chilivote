class CreateSvotes < ActiveRecord::Migration
  def change
    create_table :svotes do |t|
      t.references :status
      t.references :user
      t.integer :svote_status

      t.timestamps
    end
  end
end
