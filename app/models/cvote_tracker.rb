class CvoteTracker < ActiveRecord::Base
  #those are the votings of the users
  belongs_to :user
  belongs_to :cvote
  belongs_to :answer
end
