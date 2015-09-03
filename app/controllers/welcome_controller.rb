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
    n = Invitation.new
    n.email = params[:email]
    n.code = SecureRandom.urlsafe_base64
    n.used = false
    
    n.save
    UserMailer.welcome_email.deliver
    
    respond_to do |format|
      format.html {}
    end
  end
  
  private
  def allow_facebook_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://apps.facebook.com'
  end
end
