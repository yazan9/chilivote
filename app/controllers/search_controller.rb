class SearchController < ApplicationController
  def index
    #Variables for the left column
    @current_user = current_user
    @my_friends = @current_user.friends
    @user = @current_user
    if params[:q]
      @users_results = User.search(params[:q])
      @chilivotes_results = Contribution.search_chilivotes(params[:q])
      @statuses_results = Contribution.search_statuses(params[:q])
    end
  end
end
