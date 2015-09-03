class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.string :code
      t.boolean :used
      t.timestamps
    end
  end
end
