class SearchController < ApplicationController
  def index
    #Variables for the left column
    @current_user = current_user
    @my_friends = @current_user.friends
    @user = @current_user
    if params[:q] and params[:q] != ""
      @users_results = User.search(params[:q].downcase)
      @chilivotes_results = Contribution.search_chilivotes(params[:q].downcase)
      @statuses_results = Contribution.search_statuses(params[:q].downcase)
    end
  end
end
