class CvoteController < ApplicationController
  include SessionsHelper
  before_action :signed_in_user, only: [:new]
  before_action :current_user, only: [:create]
  
  def new
    @cvote = Cvote.new
    [:answer1, :answer2, :answer3].each { |k| session.delete(k) }
    respond_to do |format|
        format.js {render '/cvote/new/'}
    end
  end
  
  def create
    @cvote = Contribution.new
    @cvote.title = params[:cvote][:name]
    @cvote.user_id = current_user.id
    @cvote.contribution_type = Chilivote::Application.config.contribution_type_cvote
    #@cvote.privacy = Chilivote::Application.config.privacy_friends_only
    @cvote.privacy = params[:privacy] if params[:privacy]
    
    #checking for errors
    @errors = Array.new
    if params[:cvote][:name].nil? or params[:cvote][:name].strip() == ""
      @errors << "Please write a question"
    end
        
    if !session[:answer1] or !session[:answer2]
      @errors << "You have to provide at least two answers"
    end    
    
    #build the options through contribution_id
    if session[:answer1]
      @answer1 = @cvote.options.build
      @answer1.image_id = session[:answer1]
    end
    
    if session[:answer2] 
      @answer2 = @cvote.options.build
      @answer2.image_id = session[:answer2]
    end
    
    if session[:answer3] 
      @answer3 = @cvote.options.build
      @answer3.image_id = session[:answer3]
    end 
    
    #saving
    respond_to do |format|
      if @errors.size == 0 && @cvote.save
        #add a notification to my friends
        current_user.friends.each do |my_friend|
          n = Notification.new
          n.notification_type = 3
          n.user_me = my_friend.id
          n.user_friend = current_user.id
          n.target_id = @cvote.id
          n.save
        end
        format.html { 
          redirect_to "/users/" + current_user.id.to_s, notice: 'Your new Chilivote has been created !'
         }
        format.js { 
          #render :js => "window.location.href = '#{'/users/'+ current_user.id}'" , notice: 'Your new Chilivote has been created !'
          [:answer1, :answer2, :answer3].each { |k| session.delete(k) }
          render js: "window.location = '/users/#{current_user.id.to_s}';"
          }
      else
        format.html { render action: 'new', notice: "Please enter a title for your new Chilivote" }
        format.js { }
      end
    end
  end
  
  def create_deprecated
    @cvote = Cvote.new
    @cvote.name = params[:cvote][:name]
    @cvote.user_id = current_user.id
    @cvote.expiry_date = 10.years.from_now
    
    #checking for errors
    @errors = Array.new
    if params[:cvote][:name].nil? or params[:cvote][:name].strip() == ""
      @errors << "Please write a question"
    end
    
    
    if !session[:answer1] or !session[:answer2]
      #redirect_to "/cvote/start_over", notice: 'You have to submit two answers at least' and return
      @errors << "You have to provide at least two answers"
    end
    
    if session[:answer1]
      @answer1 = @cvote.answers.build
      @answer1.image_id = session[:answer1]
    end
    
    if session[:answer2] 
      @answer2 = @cvote.answers.build
      @answer2.image_id = session[:answer2]
    end
    
    if session[:answer3] 
      @answer3 = @cvote.answers.build
      @answer3.image_id = session[:answer3]
    end 
    
    
    
    
    #logger = Logger.new('logfile2.log')
    #logger.info "Attention !!!"
            
    respond_to do |format|
      if @errors.size == 0 && @cvote.save
        #add a notification to my friends
        current_user.friends.each do |my_friend|
          n = Notification.new
          n.notification_type = 3
          n.user_me = my_friend.id
          n.user_friend = current_user.id
          n.target_id = @cvote.id
          n.save

        end
        format.html { 
          redirect_to "/users/" + current_user.id.to_s, notice: 'Your new Chilivote has been created !'
           }
        format.js { 
          #render :js => "window.location.href = '#{'/users/'+ current_user.id}'" , notice: 'Your new Chilivote has been created !'
          [:answer1, :answer2, :answer3].each { |k| session.delete(k) }
          render js: "window.location = '/users/#{current_user.id.to_s}';"
          }
      else
        format.html { render action: 'new', notice: "Please enter a title for your new Chilivote" }
        format.js { }
      end
    end
  end
  
  def manage_answers
    #logger = Logger.new('logfile2.log')
    #logger.info "Started Logging ...."
    #logger.info "params[:source]=" + params[:source]
    #logger.info "params[:image_id]=" + params[:image_id]
    #logger.info "session[:answer1]=" + session[:answer1] if session[:answer1]
    #logger.info "session[:answer2]=" + session[:answer2] if session[:answer2]
    #logger.info "session[:answer3]=" + session[:answer3] if session[:answer3]
    #logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    if !session[:answer1] 
      session[:answer1] = params[:image_id]
    elsif !session[:answer2]
      session[:answer2] = params[:image_id]
    elsif !session[:answer3]
      session[:answer3] = params[:image_id]
    end
    
    #if !session[:answer1] then session[:answer1] = params[:image_id]
    #  elsif !session[:answer2] then session[:answer2] = params[:image_id] 
    #  elsif !session[:answer3] then session[:answer3] = params[:image_id] 
    #end
    #respond_to do |format|
    #    format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}
    #    format.json {render :nothing => true, :status => 200, :content_type => 'text/html'}
    #end
    respond_to do |format|
    #    format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}
        format.js {}
    end
  end
    
  def start_over
    session[:answer1] = nil
    session[:answer2] = nil
    session[:answer3] = nil
    
    redirect_to :action => :new
  end
  
  def index
    @user_votes = current_user.cvotes
  end
  
  def submit_cvote
    cvt = CvoteTracker.new
    cvt.user_id = current_user.id
    cvt.cvote_id = params[:cvote_id]
    cvt.answer_id = params[:answer_id]
    @answers = Answer.find_all_by_cvote_id(params[:cvote_id])
    @selected_answer = params[:answer_id]
    
    @voted_answer = Answer.find_by_id(@selected_answer)
    @voted_answer.likes == nil ? @voted_answer.likes = 1 : @voted_answer.likes = @voted_answer.likes + 1
        
    cvt.save
    @voted_answer.save
    
    #create the notification
    n = Notification.new
    n.notification_type = 4
    n.user_me = Cvote.find(params[:cvote_id]).user.id
    n.user_friend = current_user.id
    n.target_id = params[:cvote_id]
    n.save   
    
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end
  
  def remove_cvote
    @cvote = Cvote.find(params[:id])
    if current_user.id != @cvote.user_id
      redirect_to '/'
    end
    @cvote.destroy
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end
  
  def remove_comment
    @comment = Comment.find(params[:id])
    if current_user.id != @comment.user_id
      redirect_to '/'
    end
    @comment.destroy
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

private
  def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to '/' unless current_user?(@user)
    end
end