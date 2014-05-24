class VotesController < ApplicationController
  def create
    @post = Post.find(params[:vote][:post_id])
    current_user.vote!(@post)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
end
