class Friendship < ActiveRecord::Base
  #status of the relationship: 0 means pending, 1 means requested, 2 means accepted
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  validates_presence_of :user_id, :friend_id
  
  
  # Return true if the users are (possibly pending) friends.
  def self.exists?(user, friend)
    not find_by_user_id_and_friend_id(user, friend).nil?
  end
  
  #Record a pending friend request
  def self.request(user,friend)
    unless user == friend or Friendship.exists?(user,friend)
      transaction do
        @user_to_friend = create(:user=>user, :friend => friend, :status => 0)
        create(:user=>friend, :friend => user, :status => 1)
      end
    end
    @user_to_friend
  end
  
  #Accept a friend request
  def self.accept(user, friend)
    transaction do
      accept_one_side(user, friend)
      accept_one_side(friend, user)
    end
  end
  
  #Delete a frienship or cancel a pending request
  def self.breakup(user,friend)   
    transaction do
      destroy(find_by_user_id_and_friend_id(user.id,friend.id))
      destroy(find_by_user_id_and_friend_id(friend.id, user.id))
    end
  end
  
  private
  
  #Update the DB with one side of an accepted friendship request
  def self.accept_one_side(user,friend)
    request = find_by_user_id_and_friend_id(user, friend)
    #change status to accepted
    request.status = 2
    request.save!
  end
end