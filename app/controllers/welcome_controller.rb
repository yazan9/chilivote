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
  
  private
  def allow_facebook_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://apps.facebook.com'
  end
end
