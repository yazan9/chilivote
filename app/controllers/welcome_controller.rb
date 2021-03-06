class WelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  after_action :allow_facebook_iframe
  require "base64"  
  def index
    @user = User.new
    if !current_user.nil?
      redirect_to "/users/show_public"
    end
  end
  
  def test_json
  web_contents  = open('https://upload.wikimedia.org/wikipedia/en/a/a9/Example.jpg') {|f| f.read }
  encoded = Base64.encode64(web_contents)
  #decoded_file = Base64.decode64(encoded)
  #file = Tempfile.new("temp") 
  #file.path
  #file.binmode
  #file.write decoded_file
  #Cloudinary::Uploader.upload(file.path)
  #file.close
  #file.unlink
  render :text => encoded, :layout => false
  end
  
  def about
  #web_contents  = open('https://upload.wikimedia.org/wikipedia/en/a/a9/Example.jpg') {|f| f.read }
  #encoded = Base64.encode64(web_contents)
  #decoded_file = Base64.decode64(encoded)
  #file = Tempfile.new("temp") 
  #file.path
  #file.binmode
  #file.write decoded_file
  #Cloudinary::Uploader.upload(file.path)
  #file.close
  #file.unlink
  #render :text => encoded, :layout => false
  end
  
  def help
    
  end
  
  def news
    
  end
  
  def contact
    
  end
  
  def from_fb
    #render layout: false
    @user = User.new
    render :index
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
        format.html {redirect_to :action => :thank_you, :code => @n.code}
        format.js {render :js => "window.location = '/welcome/thank_you?code=#{@n.code}'"}
      end
    else
      #flash[:notice] = "Please enter a valid email"
      respond_to do |format|
        format.html {redirect_to :action => :thank_you, :code => @n.code}
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
    #@code = params[:code]
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
