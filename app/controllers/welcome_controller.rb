class WelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  after_action :allow_facebook_iframe
  
  def index
    if !current_user.nil?
      redirect_to "/users/show_public"
    end
  end
  
  def about
    
  end
  
  def help
    
  end
  
  def news
    
  end
  
  def contact
    
  end
  
  def from_fb
    render layout: false
    #redirect_to '/'
  end
  
  def request_invitation
    @n = Invitation.new
    @n.email = params[:email]
    @n.code = SecureRandom.urlsafe_base64
    @n.used = false
 
    if @n.save
      UserMailer.welcome_email(params[:email], @n.code).deliver
      respond_to do |format|
        format.js
      end
    else
      #flash[:notice] = "Please enter a valid email"
      respond_to do |format|
        format.html {redirect_to :action => :index}
        format.js
      end
    end
  end
  
  def request_invitation_from_fb
    if !current_user.nil?
      redirect_to "/users/show_public"
    end
  end
  
  def thank_you
    
  end
  
  def forgot_password
  end
  
  def reset_password
    #logger = Logger.new('logfile3.log')
    @user = User.find_by_email(params[:email])
    if !@user.nil?
      @decoded_password = [*('A' .. 'Z')].sample(8).join
      @user.password = @decoded_password
      @user.password_confirmation = @decoded_password
    end
    if @user.save
      PasswordMailer.reset_password(@user.email, @decoded_password).deliver
      respond_to do |format|
        format.html
      end
    end
      #flash[:notice] = "Please enter a valid email"
  end
  
  private
  def allow_facebook_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://apps.facebook.com'
  end
end
