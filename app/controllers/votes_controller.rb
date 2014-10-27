class VotesController < ApplicationController
  before_action :signed_in_user
  def create
    @post = Post.find(params[:vote][:post_id])
    current_user.vote!(@post)
    
    n = Notification.new
    n.notification_type = 1
    n.user_me = @post.user.id
    n.user_friend = current_user.id
    n.target_id = @post.id
    n.save
    
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
  
  def destroy
    @post = Post.find(params[:vote][:post_id])
    current_user.unvote!(@post)
    
    n = Notification.find_by_notification_type_and_user_me_and_user_friend_and_target_id(1,@post.user.id,current_user.id, @post.id)
    n.destroy
    
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
  
  private
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
end
