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
        format.html { redirect_to action: 'index', notice: 'Your new Chilivote has been created !' }
        format.json { }
      else
        format.html { redirect_to action: 'index' }
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
    cvt.save   
    
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