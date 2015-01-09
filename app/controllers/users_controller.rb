class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :add_avatar]
  before_action :admin_user, only:[:destroy, :index]


  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  #variable @user is automatically initialized
  def show
    @is_current_user = current_user?(@user)
    @is_signed_in = signed_in?
    @logged_in_user = current_user
    @friendship = Friendship.find_by_user_id_and_friend_id(@logged_in_user, @user)
    @cvotes = @user.cvotes.where("expiry_date > ?", DateTime.now).order(created_at: :desc)
    
    if params[:mode] == "self" && @is_signed_in
      @my_own_cvotes = @logged_in_user.cvotes.order(created_at: :desc)
    end
    
    if @is_signed_in
      @friends = @logged_in_user.friends
      @my_friends_cvotes = Array.new
      @friends.each do |friend|
        friend.cvotes.where("expiry_date > ?", DateTime.now).each do |cvote|
          @my_friends_cvotes << cvote
        end
      end
      
      @logged_in_user.cvotes.each do |cvote|
        @my_friends_cvotes << cvote
      end
      
      @my_friends_cvotes = @my_friends_cvotes.sort_by { |obj| obj.created_at }.reverse!
    else
      @friends = nil
    end
  end

  # GET /users/new
  def new
    @user = User.new
    if !current_user.nil?
      redirect_to "/users/" + current_user.id.to_s
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: 'Well Done ! You can now live the chilivote experience !' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Profile Updated' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  def add_avatar
    @user = User.find(params[:id])
    @user.profile_image = params[:image_id]
    respond_to do |format|
      if @user.save
        format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}
        format.json {render :nothing => true, :status => 200, :content_type => 'text/html'}
      else
        format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}
        format.json {render :nothing => true, :status => 200, :content_type => 'text/html'}
      end
    end
  end
  
  def list_friends
    if signed_in?
      @user=current_user
      @friends = @user.friends
    else
      redirect_to root
    end
  end
  
  def clear_notifications
   # @notifications = Notification.where(user_me: current_user.id)
    #@notifications.each do |notification|
      #notification.destroy
    #end
    
    @notification = Notification.find(params[:id])
    if current_user.id != @notification.user_me
      redirect_to '/' and return
    end
    
    @notification.viewed = true
    @notification.save
    
    @notifications = Notification.where(user_me: current_user.id)
    @notifications.each do |notification|
      if (Time.now - notification.created_at)/1.day > 7
        notification.destroy
      end
    end
    
    respond_to do |format|
        format.js
    end
  end
  
  def search
    @q = "%" + params[:q] + "%"
    @search_results =   User.find(:all, :conditions => ['lower(first_name) LIKE ? OR lower(last_name) LIKE ?', @q.downcase, @q.downcase])    
  end
  
  def create_comment
    @comment = Comment.new
    @cvote_id = params[:cid]
    @comment.cvote_id = params[:cid]
    @comment.user_id = current_user.id
    @comment.text = params[:text]
    @comment.save!
    
    respond_to do |format|
        format.js
                format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}

    end
  end
  
  def list_voters
    
    respond_to do |format|
      @cvote_trackers = CvoteTracker.find_all_by_answer_id params[:answer_id]
        format.js
        format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :gender, :password, :password_confirmation, :image_id, :dob, :country_id)
    end
    
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
    
    def admin_user
      redirect_to '/' unless current_user.admin?
    end
    
    
end
