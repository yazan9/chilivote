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
    #logger = Logger.new('logfile2.log')
    #logger.info "inside vote up _____________________"
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
  
  def vote_status_up     
    #make sure the contribution exists
    @contribution = Contribution.find(params[:id])
    if @contribution.nil?
      redirect_to "/" and return
    end
    
    #make sure the user is a friend of the owner of the status
    if !Friendship.exists?(current_user, @contribution.user) && @contribution.contribution_type == Chilivote::Application.config.privacy_friends_only
      #hack attempt, exit
      redirect_to "/" and return  
    end
      
    #make sure that the user did not vote before
    if current_user.voted_on_status?(@contribution)
      redirect_to "/" and return
    end
    
    current_user.vote_status_up!(@contribution)
    n = Notification.new
    n.notification_type = 1
    n.user_me = @contribution.user_id
    n.user_friend = current_user.id
    n.target_id = @contribution.id
    n.save   
   
    respond_to do |format|
      format.js
    end
  end
  
  def vote_status_down
    #make sure the contribution exists
    @contribution = Contribution.find(params[:id])
    if @contribution.nil?
      redirect_to "/" and return
    end
    
    #make sure the user is a friend of the owner of the status
    if !Friendship.exists?(current_user, @contribution.user) && @contribution.contribution_type == Chilivote::Application.config.privacy_friends_only
      redirect_to "/" and return
    end
      
    #make sure that the user did not vote before
    if current_user.voted_on_status?(@contribution)
      redirect_to "/" and return
    end
    
    current_user.vote_status_down!(@contribution)
    n = Notification.new
    n.notification_type = 9
    n.user_me = @contribution.user_id
    n.user_friend = current_user.id
    n.target_id = @contribution.id
    n.save   
   
    respond_to do |format|
      format.js
    end
  end
  
  def vote_on_cvote
    logger = Logger.new('logfile2.log')
    logger.info "inside vote on cvote !!!!!!!!!!!"
    #make sure the contribution exists
    @contribution = Contribution.find(params[:cvote_id])
    @answer = Contribution.find(params[:answer_id])
    if @contribution.nil? or @answer.nil?
      redirect_to "/" and return
    end
    logger.info "passed 1"
    #make sure the user is a friend of the owner of the cvote
    if !Friendship.exists?(current_user, @contribution.user) and @contribution.privacy == Chilivote::Application.config.privacy_friends_only
      redirect_to "/" and return
    end
    logger.info "passed 2"
      
    #make sure that the user did not vote before
    if current_user.voted_on_cvote?(@contribution)
      redirect_to "/" and return
    end
    logger.info "passed 3"
    
    
    current_user.place_vote_on_cvote!(@contribution, @answer)
    #create the notification
    n = Notification.new
    n.notification_type = 4
    n.user_me = @contribution.user_id
    n.user_friend = current_user.id
    n.target_id = @contribution.id
    n.save   
   
    respond_to do |format|
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
