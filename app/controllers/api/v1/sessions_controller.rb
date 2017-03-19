class Api::V1::SessionsController < SessionsController
  def create
   user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      remember_token = User.new_remember_token
      user.update_attribute(:remember_token, User.digest(remember_token))

      render json: user, :except=>  [:password_digest, :admin, :promoted, :external]
    else
        render :text => "failed"
    end
  end
end