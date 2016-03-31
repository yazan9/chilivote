class SessionsController < ApplicationController
  def new
  end

  def create
   user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user
      #render 'users/' + user.id.to_s
      #redirect_back_or user
      #redirect_to '/users/'+user.id.to_s
      redirect_to '/users/show_public'
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end  
  end
  
  def create_from_fb
    user = User.from_omniauth(env["omniauth.auth"])   
      #Rails.logger.info("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm")
      #Rails.logger.info(user.id.to_s)

    #user = User.find_by(email: params[:session][:email].downcase)
    #if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
    sign_in user
    redirect_to '/categories/list_categories/'
    #else
     # flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      #render 'new'
    #end  
  end

  def destroy
    sign_out
    redirect_to '/'
  end
end
