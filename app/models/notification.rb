class Notification < ActiveRecord::Base
  belongs_to :user, :primary_key => :id, :foreign_key => :user_friend 
end
#notification_type works as follows:
# 1: someone liked my photo in the main categories
# 2: someone accepted my friend request
# 3: my friend created a chilivote
# 4: my friend voted on my chilivote
# 5: my friend uploaded a photo in categories