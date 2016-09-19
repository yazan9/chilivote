class Friendship < ActiveRecord::Base
  #status of the relationship: 0 means pending, 1 means requested, 2 means accepted, 3 means following, 4 means followed by
  #if two users are friends, there is no follow relationship, there cannot be one
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  validates_presence_of :user_id, :friend_id
  
  
  # Return true if the users are friends.
  def self.exists?(user, friend)
    not find_by_user_id_and_friend_id_and_status(user, friend, 2).nil?
  end
  
  def self.following?(user, friend)
    not find_by_user_id_and_friend_id_and_status(user,friend,3).nil?
  end
  
  def self.requested?(user, friend)
    not find_by_user_id_and_friend_id_and_status(user, friend, 0).nil? and find_by_user_id_and_friend_id_and_status(friend, user, 0).nil?
  end
  
  def self.request_received(user, friend)
    not find_by_user_id_and_friend_id_and_status(user, friend, 1).nil?
  end
  
  #Record a pending friend request
  def self.request(user,friend)
    unless user == friend or Friendship.exists?(user,friend) or Friendship.requested?(user,friend) or Friendship.request_received(friend,user)
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
  
  
  def self.follow(user,friend)
    unless user == friend or Friendship.exists?(user,friend)
      transaction do
        @user_to_friend = create(:user=>user, :friend => friend, :status => 3)
        create(:user=>friend, :friend => user, :status => 4)
      end
    end
    @user_to_friend
  end
  
  def self.unfollow(user,friend)
    transaction do
      destroy(find_by_user_id_and_friend_id_and_status(user.id,friend.id,3))
      destroy(find_by_user_id_and_friend_id_and_status(friend.id, user.id, 4))
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
