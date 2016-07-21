class Comment < ActiveRecord::Base
  belongs_to :user
  #belongs_to :cvote
  belongs_to :contribution, :primary_key => :id, :foreign_key => :cvote_id
end
