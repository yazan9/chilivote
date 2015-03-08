class CreateVoteOptions < ActiveRecord::Migration
  def change
    create_table :vote_options do |t|
      t.string :title
      t.references :poll, index: true
      t.boolean :correct_answer, :default => :false

      t.timestamps
    end
  end
end
