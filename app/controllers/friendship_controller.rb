class FriendshipController < ApplicationController
  before_filter :setup_users_friends
  include SessionsHelper
  
  #send a friend request
  def create
    @friendship = Friendship.request(@user, @friend)
    respond_to do |format|
      if !@friendship.nil?
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
    
    respond_to do |format|
      format.js
    end
  end
  
  def accept
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
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
  
  private
  
  def setup_users_friends
    @user = current_user
    @friend = User.find(params[:id])
  end
end
