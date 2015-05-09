class WelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
  end
  
  def about
    redirect_to :action => :help
  end
  
  def help
    
  end
  
  def news
    
  end
  
  def contact
    
  end
end
