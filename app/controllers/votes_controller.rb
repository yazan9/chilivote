class VotesController < ApplicationController
  before_action :signed_in_user
  def create
    @post = Post.find(params[:vote][:post_id])
    current_user.vote!(@post)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
  
  def destroy
    @post = Post.find(params[:vote][:post_id])
    current_user.unvote!(@post)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
  
  private
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
end
