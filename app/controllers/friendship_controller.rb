class FriendshipController < ApplicationController
  before_filter :setup_users_friends
  include SessionsHelper
  
  #send a friend request
  def create
    @friendship = Friendship.request(@user, @friend)
    respond_to do |format|
      if !@friendship.nil?
        @is_friendship_requested = true
        format.js
      else
        format.js {render "an error occured"}
      end
    end
  end
  
  #remove friend
  def unfriend
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
    end
    @friendship = nil
    @viewed_user = @friend
    respond_to do |format|
      format.js
    end
  end
  
  def accept
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
      
      n = Notification.new
      n.notification_type = 2
      n.user_me = @friend.id
      n.user_friend = @user.id
      n.target_id = nil
      n.save 
      
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def decline
    if @user.requested_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def follow_user
    if !@user.followed_users.include?(@friend)
      Friendship.follow(@user, @friend)
      
      n = Notification.new
      n.notification_type = 10
      n.user_me = @friend.id
      n.user_friend = @user.id
      n.target_id = nil
      n.save 
    end
    
     respond_to do |format|
       format.js
    end
  end
  
  def unfollow_user
    if @user.followed_users.include?(@friend)
      Friendship.unfollow(@user, @friend)
    end
    
     respond_to do |format|
       format.js
    end
  end
  
  private
  
  def setup_users_friends
    @user = current_user
    @friend = User.find(params[:id])
  end
end
