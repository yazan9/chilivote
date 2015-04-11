class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :user, index: true
      t.string :title
      t.integer :status_type
      t.timestamps
    end
  end
end
