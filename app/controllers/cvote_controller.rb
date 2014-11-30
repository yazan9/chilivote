class CvoteController < ApplicationController
  include SessionsHelper
  before_action :signed_in_user, only: [:new]
  before_action :current_user, only: [:create]
  
  def new
    @cvote = Cvote.new
    [:answer1, :answer2, :answer3, :answer4].each { |k| session.delete(k) }
  end
  
  def create
    @cvote = Cvote.new
    @cvote.name = params[:cvote][:name]
    @cvote.user_id = current_user.id
    #scan the expiy date
    if params[:expiry_date] == "1 day"
      @cvote.expiry_date = 1.day.from_now
    elsif params[:expiry_date] == "2 days"
      @cvote.expiry_date = 2.days.from_now
    elsif params[:expiry_date] == "3 days"
      @cvote.expiry_date = 3.days.from_now
    elsif params[:expiry_date] == "1 week"
      @cvote.expiry_date = 1.week.from_now
    elsif params[:expiry_date] == "1 month"
      @cvote.expiry_date = 1.month.from_now
    elsif params[:expiry_date] == "Forever"
      @cvote.expiry_date = 10.years.from_now
    else
      @cvote.expiry_date = 10.years.from_now
    end
    
    if !session[:answer1] or !session[:answer2]
      redirect_to "/cvote/start_over", notice: 'You have to submit two answers at least' and return
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
    
    if session[:answer4] 
      @answer4 = @cvote.answers.build
      @answer4.image_id = session[:answer4]
    end
    
    [:answer1, :answer2, :answer3, :answer4].each { |k| session.delete(k) }
    
      
    
            
    respond_to do |format|
      if @cvote.save
        #add a notification to my friends
        current_user.friends.each do |my_friend|
          n = Notification.new
          n.notification_type = 3
          n.user_me = my_friend.id
          n.user_friend = current_user.id
          n.target_id = @cvote.id
          n.save
        end
        format.html { redirect_to "/users/" + current_user.id.to_s, notice: 'Your new Chilivote has been created !' }
        format.json { }
      else
        format.html { render action: 'new', notice: "Please enter a title for your new Chilivote" }
        format.json { }
      end
    end
  end
  
  def manage_answers
    if !session[:answer1] then session[:answer1] = params[:image_id]
      elsif !session[:answer2] then session[:answer2] = params[:image_id] 
      elsif !session[:answer3] then session[:answer3] = params[:image_id] 
      elsif !session[:answer4] then session[:answer4] = params[:image_id] 
    end
    respond_to do |format|
        format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}
        format.json {render :nothing => true, :status => 200, :content_type => 'text/html'}
    end
  end
    
  def start_over
    session[:answer1] = nil
    session[:answer2] = nil
    session[:answer3] = nil
    session[:answer4] = nil
    
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