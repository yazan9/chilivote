class Like < ActiveRecord::Base
  belongs_to :user
  #maybe i will need to add primary key, like the notifications model
  belongs_to :contribution, :primary_key => :id, :foreign_key => :target_id
end
