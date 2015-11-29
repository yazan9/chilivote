class WelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  after_action :allow_facebook_iframe
  
  def index
    
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
  
  private
  def allow_facebook_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://apps.facebook.com'
  end
end
