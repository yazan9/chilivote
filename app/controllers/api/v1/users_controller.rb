class Api::V1::UsersController < UsersController

def create_status_m
  current_user = set_current_user
  if !current_user.nil?
  @status = Contribution.new
  @status.user_id = current_user.id
  @status.body = params[:status_text]
  @status.contribution_type = Chilivote::Application.config.contribution_type_status
  @status.privacy = params[:privacy] if params[:privacy]
  if params[:image]
    decoded_file = Base64.decode64(params[:image])
    file = Tempfile.new("temp")
    file.path
    file.binmode
    file.write decoded_file
    cloud_file = Cloudinary::Uploader.upload(file.path)
    file.close
    file.unlink
    @status.image_id = cloud_file["public_id"]
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
render json: "ok"
else
      render json: "not ok"
  end
end

  def show
    user = User.find(params[:id])

    #render(json: Api::V1::UserSerializer.new(user).to_json)
    #render :text => "success"
    render json: user
  end
  
  def create
    @user = User.new
    @user.first_name = params[:first_name]
    @user.email = params[:email]
    @user.password = params[:password]
 
    #Modifying the name ############################
    if @user.first_name.split.length > 1
    first_name = @user.first_name.split(' ',2).first
    last_name = @user.first_name.split(' ',2).last
    else
      first_name = @user.first_name
      last_name = ""
    end
    if last_name.nil?
      last_name = ""
    end
    @user.first_name = first_name
    @user.last_name = last_name
    ################################################
    
    @user.password_confirmation = @user.password
    
    #checking for errors
    @errors = Array.new
    if @user.first_name.nil? or @user.password.nil? or @user.email.nil?
      @errors<<"Please fill in all the fields"
    elsif @user.first_name.strip()=="" or @user.password.strip()=="" or @user.email.strip()==""
      @errors<<"Please fill in all the fields"
    elsif !User.find_by_email(@user.email.downcase).nil?
      @errors<<"email address is already in use"
    end
    
      if @errors.size == 0
        @user.save
        sign_in @user
        render json: "success"
      else
        render json: @errors
      end
  end
  private
  def set_current_user
    current_user = Object.new
    authenticate_or_request_with_http_token do |token, options|
      current_user = User.find_by(remember_token: token)
    end
    return current_user
  end
end