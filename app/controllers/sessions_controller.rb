class SessionsController < ApplicationController
  def new
  end

  def create
   user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      if user.external == false
      sign_in user
      #render 'users/' + user.id.to_s
      #redirect_back_or user
      #redirect_to '/users/'+user.id.to_s
      respond_to do |format|
      format.html {redirect_to '/users/show_public'}
      format.json {render json: user, :except=>  [:password_digest, :admin, :promoted, :external]}
    end
      else
        respond_to do |format|
        format.html {redirect_to "/"}
        format.json {render :text => "failed"}
      end
      end
    else
      respond_to do |format|
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      format.html {render 'new'}
      format.json {render :text => "failed"}
    end
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
    redirect_to '/users/show_public'
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
