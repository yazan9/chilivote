class PollsController < ApplicationController
  include SessionsHelper
  def new
    @poll = Poll.new
  end
  
  def index
    @polls = current_user.polls.order(created_at: :desc)
  end
 
  def create
    @poll = Poll.new(poll_params)
    @poll.user_id = current_user.id
    if @poll.save
      current_user.friends.each do |my_friend|
          n = Notification.new
          n.notification_type = 6
          n.user_me = my_friend.id
          n.user_friend = current_user.id
          n.target_id = @poll.id
          n.save
        end
      #flash[:success] = 'Poll was created!'
      #redirect_to polls_path
      redirect_to "/polls/", notice: 'Your new True Friends Question has been created !'
    else
      render 'new'
    end
  end
  
  def destroy
    @poll = Poll.find_by_id(params[:id])
    if @poll.destroy
      flash[:success] = 'Question was removed!'
    else
      flash[:warning] = 'Error removing question...'
    end
    redirect_to polls_path
  end
 
  private
 
  def poll_params
    params.require(:poll).permit(:topic, vote_options_attributes: [:id, :title, :correct_answer, :_destroy])
  end
end
