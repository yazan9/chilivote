class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :activity, :show]
  before_action :correct_user,   only: [:edit, :update, :add_avatar]
  before_action :admin_user, only:[:destroy, :index, :activity]


  # GET /users
  # GET /users.json
  def index
    @users = User.all.order(created_at: :asc)
  end

  # GET /users/1
  # GET /users/1.json
  #variable @user is automatically initialized
  def show
    #setting flags
    @is_current_user = current_user?(@user)
    
    #setting other variables
    @current_user = current_user
    @target_user = @user
    
    #getting list of friends
    @my_friends = @current_user.friends
    
    #scenario 1: the timeline is mine
    if @current_user == @target_user
      @friend_ids = @current_user.friend_ids
      @friend_ids << @current_user.id
      
      @timeline_items = Contribution.where(user_id: @friend_ids).order(created_at: :desc)
      #logger = Logger.new('logfile2.log')
      #logger.info "timeline................."
      #logger.info @friend_ids
    else
      #@friendship = Friendship.find_by_user_id_and_friend_id(@current_user, @target_user)
      #Scenario two: The timeline belongs to my friend
      #if !@friendship.nil?
      #  @timeline_items = Contribution.where(user_id: @target_user).order(created_at: :desc)
      #else
      #  render :show_other_user
      #end 
      redirect_to :action => :show_profile, :id=>@target_user.id
    end
  end
  
  def show_friend_requests
    respond_to do |format|
      format.js
    end
  end
  
  def show_notifications
    respond_to do |format|
      format.js
    end
  end
  
  def show_deprecated
    @is_current_user = current_user?(@user)
    @is_signed_in = signed_in?
    @current_user = current_user
    
    if @is_current_user
      @logged_in_user = @current_user
    else
      @logged_in_user = @user
    end
    #@friendship = Friendship.find_by_user_id_and_friend_id(@logged_in_user, @user)
    @friendship = Friendship.find_by_user_id_and_friend_id(@current_user, @logged_in_user)
    @cvotes = @user.cvotes.where("expiry_date > ?", DateTime.now).order(created_at: :desc)
    
    #if params[:mode] == "self" && @is_signed_in
    #  @my_own_cvotes = @logged_in_user.cvotes.order(created_at: :desc)
    #end
    
    
    
    if @is_signed_in
      @friends = @logged_in_user.friends
      @my_friends = current_user.friends
      @my_friends_cvotes = Array.new
      @friends.each do |friend|
        friend.cvotes.where("expiry_date > ?", DateTime.now).each do |cvote|
          @my_friends_cvotes << cvote if (@my_friends.include?(cvote.user))
          @my_friends_cvotes << cvote if cvote.user.id == @current_user.id
        end
        #adding code for friends questions
        friend.polls.each do |poll|
          @my_friends_cvotes << poll if (@my_friends.include?(poll.user))
          @my_friends_cvotes << poll if poll.user.id == @current_user.id
        end
      end
      
      @logged_in_user.cvotes.each do |cvote|
        @my_friends_cvotes << cvote
      end
      
      @logged_in_user.polls.each do |poll|
        @my_friends_cvotes << poll
      end
      
      @my_friends_cvotes = @my_friends_cvotes.sort_by { |obj| obj.created_at }.reverse!
      
      #modified the following line with pagination, remove_if_fucks_up
      #@paginated_elements = @my_friends_cvotes.paginate(page: params[:page], per_page: 20)
     
     # @best_friend = get_best_friend(@logged_in_user.id)
    else
      @friends = nil
    end
    
    @best_friends = get_best_friends
    
    #modified the following block with pagination, remove_if_fucks_up
    #respond_to do |format|
    #  format.html
    #  format.js
    #end
  end

  # GET /users/new
  def new
    @user = User.new
    if !current_user.nil?
      #redirect_to "/users/" + current_user.id.to_s
      #redirect_to "/users/advanced_data"
    end
    if !params[:code].nil? 
      @code = params[:code] 
    else 
      @code = nil
    end 
    render '/users/forms/form_basic'
  end
  
  def advanced_data
    @user = current_user
    render "/users/forms/advanced_data"
  end

  def show_profile
    @current_user = current_user
    @my_friends = @current_user.friends
    @user = @current_user
    
    @viewed_user = User.find(params[:id])
    #@friendship = Friendship.find_by_user_id_and_friend_id(@current_user.id, @viewed_user.id)    
    #setting flags
    @is_friend = Friendship.exists?(@current_user, @viewed_user)
    @is_friendship_requested = Friendship.requested?(@current_user, @viewed_user)
    @is_friendship_request_received = Friendship.request_received(@current_user, @viewed_user)
    
    #Creating timeline
    if @is_friend
       @timeline_items = Contribution.where(user_id: @viewed_user.id).order(created_at: :desc)
    else
      @timeline_items = Contribution.where(user_id: @viewed_user.id, :privacy => Chilivote::Application.config.privacy_public).order(created_at: :desc)
    end
  end
  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @invitation = Invitation.find_by_code(params[:confirmation_code])
    @user.email = @invitation.email
    
    respond_to do |format|
      if @user.save
        #make chilivote friends with everybody
        #Friendship.request(User.find(@user.id), User.find(3))
        #Friendship.accept(User.find(@user.id), User.find(3))
        
        sign_in @user
        redirect_to "/users/advanced_data" and return
        format.html { redirect_to @user, notice: 'Well Done ! You can now live the chilivote experience !' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'form_basic' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to "/users/show_profile/"+@user.id.to_s, notice: 'Profile Updated' }
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
    
    if !params[:mode].nil? and params[:mode] == "all"  
      @notifications = Notification.where(user_me: current_user.id)
      @notifications.each do |notification|
          notification.destroy
      end
      
      respond_to do |format|
        format.js
      end
      return
    end
    
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
    @contribution_id = params[:cid]
    @comment.cvote_id = params[:cid]
    @comment.user_id = current_user.id
    @comment.text = params[:text]
    @comment.save!
    
    respond_to do |format|
        format.js
                format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}

    end
  end
  
  #this is the latest create status
  def create_status
   #  logger = Logger.new('logfile2.log')
   #   logger.info "provacyyyyyyyyyyyyyyyyyyyyyy"
   # logger.info params[:privacy]
    @status = Contribution.new
    @status.user_id = current_user.id
    @status.body = params[:status_text]
    @status.contribution_type = Chilivote::Application.config.contribution_type_status
    @status.privacy = params[:privacy] if params[:privacy]
    if session[:photo_for_status]
      @status.image_id = session[:photo_for_status]
      session.delete(:photo_for_status)
    end
    @status.save!
    current_user.friends.each do |my_friend|
          n = Notification.new
          n.notification_type = 5
          n.user_me = my_friend.id
          n.user_friend = current_user.id
          n.target_id = @status.id
          n.save
    end
    respond_to do |format|
      format.js
      format.html {render :nothing=>true, :status => 200, :content_type => 'text/html'}
    end    
  end
  
  def add_photo_to_status
    session[:photo_for_status] = params[:image_id]
    respond_to do |format|
      format.js {render :nothing=>true, :status => 200, :content_type => 'text/html'}
    end
  end
  
  def show_public
    if params[:view] == "public" or params[:view].nil?
      @timeline_items = Contribution.where(privacy: Chilivote::Application.config.privacy_public).order(created_at: :desc)
    elsif params[:view] == "followees"
      @timeline_items = Contribution.where("privacy = ? AND user_id IN (?)", Chilivote::Application.config.privacy_public, current_user.followed_users.pluck(:id)).order(created_at: :desc)
    elsif params[:view] == "favorites"
            @timeline_items = Contribution.where("privacy = ? AND user_id IN (?)", Chilivote::Application.config.privacy_public, current_user.favored_users.pluck(:id)).order(created_at: :desc)
       elsif params[:view] == "country"
            @timeline_items = Contribution.where("privacy = ? AND user_id IN (?)", Chilivote::Application.config.privacy_public, current_user.compatriots).order(created_at: :desc)
      elsif params[:view] == "top"
      most_active = Like.order("count_all desc").count(group: :target_id)
      @timeline_items = Array.new
      #logger = Logger.new('logfile3.log')
      #logger.info "provacyyyyyyyyyyyyyyyyyyyyyy"
    
      most_active.each do |m|
        #logger.info m[0]
        c = Contribution.find_by_id_and_privacy(m[0], Chilivote::Application.config.privacy_public)
        @timeline_items << c if !c.nil?
      end
    else
      @timeline_items = {}
    end
    @current_user = current_user
    @user = @current_user
    render '/users/public_views/show_public'
  end
  
  #deprecated
  def create_status_depricated
    @status = Status.find_by_user_id(current_user.id)
    destroy_related_notifications(@status) if !@status.nil?
    @status.destroy! if !@status.nil?
    
    
    @status = Status.new
    @status.user_id = current_user.id
    if params[:image_id].nil?
      @status.title = params[:status_title]
      @status.status_type = 1
    else
      @status.title = params[:image_id]
      @status.status_type = 2
    end
    @status.save!
    
    #create notification
    current_user.friends.each do |my_friend|
          n = Notification.new
          n.notification_type = 8
          n.user_me = my_friend.id
          n.user_friend = current_user.id
          n.target_id = current_user.id
          n.save
      end
      
      respond_to do |format|
        format.js
          format.html {render :nothing=>true, :status => 200, :content_type => 'text/html'}
      end    
  end
  
  def list_voters
    
    respond_to do |format|
      @cvote_trackers = CvoteTracker.find_all_by_answer_id params[:answer_id]
        format.js
        format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}
    end
  end
  
    def best_friends
      #logger = Logger.new('logfile2.log')
      #logger.info "3434343434344"
      #Get my polls
      if params[:id] == current_user.id.to_s
        @user = current_user
        #logger.info "here1"
      else
        @user = User.find(params[:id])
        #logger.info "here222222222222"
        redirect_to '/' and return if !current_user.friends.include?(@user)
      end
    
      @polls = @user.polls.order(created_at: :desc)
    
      # Get array of arrays of who answered what [user_id, vopte_option_id]
      @who_participated = Array.new
      @polls.each do |p|
        p.pvotes.each do |pvote|
          @who_participated<< [pvote.user_id, pvote.vote_option_id]
        end
      end
    
      #Get all answers from the vote_options table that correspond to the ids found above -- produces a hash
      @all_answers = Array.new
      @who_participated.each do |w|
        @all_answers << VoteOption.find_by_id_and_correct_answer(w[1], true)
      end
    
      #Add 0 or 1 depending on the answer whether wrong or right
      cntr = 0
      @who_participated.each do |w|
        if @all_answers[cntr].nil?
          w << 0
        else
          w << 1
        end
        cntr+=1
      end
    
      @best_friends = Array.new
    
    #Compare
      @who_participated.each do |p|
        if p[2] == 1
          @best_friends << p[0]
        end
      end
    
      #Count Occurances and sort
      counts = Hash.new 0
      @best_friends.each do |friend|
        counts[friend] += 1
      end
    
      @best_friends_sorted = counts.sort_by { |user_id, occurance| occurance }.reverse
    end
    
    def activity
      @user = User.find(params[:user_id])
      @cvotes = @user.cvotes
      @posts = @user.posts
      @polls = @user.polls
    end
  
  def toggle_privacy
    @privacy = params[:privacy]
    respond_to do |format|
      format.js
      format.html {render :nothing=>true, :status => 200, :content_type => 'text/html'}
    end    
  end
  
  def show_options_bubble
    @contribution_id = params[:id]
    @contribution = Contribution.find(@contribution_id)
    respond_to do |format|
      format.js
    end
  end
  
  def suggestions
    @current_user = current_user
    
    #getting list of friends
    @my_friends = @current_user.friends
    
    @user = @current_user
    @suggested_accounts = User.limit(5).order("RANDOM()")
    @promoted_accounts = User.where("promoted = 't'").limit(5).order("RANDOM()")
  end
  
  def followers_following
    @current_user = current_user
    
    #getting list of friends
    @my_friends = @current_user.friends
    
    @user = @current_user
    @suggested_accounts = User.limit(5).order("RANDOM()")
    @promoted_accounts = User.where("promoted = 't'").limit(5).order("RANDOM()")
    if params[:display] == "followers"
       @display_users = @current_user.followers
    else
       @display_users = @current_user.followed_users
    end
  end
  
  def public_notifications
    
    @current_user = current_user

    #getting list of friends
    @my_friends = @current_user.friends  
    @user = @current_user
    
    @notifications = @current_user.notifications.where(notification_type: [1,9,10])
  end
       
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :gender, :password, :password_confirmation, :image_id, :dob, :country_id, :confirmation_code, :about)
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
    
    def destroy_related_notifications(status)
      Notification.destroy_all(target_id: status.user_id, notification_type: 8)      
    end
      
  
    
    
    def get_best_friends
      #Get my polls
      if params[:id] == current_user.id
        @user = current_user
      else
        @user = User.find(params[:id])
      end
    
      @polls = @user.polls.order(created_at: :desc)
    
      # Get array of arrays of who answered what [user_id, vopte_option_id]
      @who_participated = Array.new
      @polls.each do |p|
        p.pvotes.each do |pvote|
          @who_participated<< [pvote.user_id, pvote.vote_option_id]
        end
      end
    
      #Get all answers from the vote_options table that correspond to the ids found above -- produces a hash
      @all_answers = Array.new
      @who_participated.each do |w|
        @all_answers << VoteOption.find_by_id_and_correct_answer(w[1], true)
      end
    
      #Add 0 or 1 depending on the answer whether wrong or right
      cntr = 0
      @who_participated.each do |w|
        if @all_answers[cntr].nil?
          w << 0
        else
          w << 1
        end
        cntr+=1
      end
    
      @best_friends = Array.new
    
    #Compare
      @who_participated.each do |p|
        if p[2] == 1
          @best_friends << p[0]
        end
      end
    
      #Count Occurances and sort
      counts = Hash.new 0
      @best_friends.each do |friend|
        counts[friend] += 1
      end
    
      @best_friends_sorted = counts.sort_by { |user_id, occurance| occurance }.reverse.take(5)
      return @best_friends_sorted
    end  
end
