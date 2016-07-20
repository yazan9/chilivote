class PollsController < ApplicationController
  include SessionsHelper
  def new
    @poll = Poll.new
  end
  
  def index
    #Get my polls
    @polls = current_user.polls.order(created_at: :desc)
    
    # Get array of arrays of who answered what [user_id, vopte_option_id]
    @who_participated = Array.new
    @polls.each do |p|
      p.pvotes.each do |pvote|
        @who_participated<< [pvote.user_id, pvote.vote_option_id]
      end
    end
    
    #Get all answers from the vote_options table that correspond to the ids found above -- produces a hash
    @all_answers = Array.new
    @who_participated.each do |w|
      @all_answers << VoteOption.find_by_id_and_correct_answer(w[1], true)
    end
    
    #Add 0 or 1 depending on the answer whether wrong or right
    cntr = 0
     @who_participated.each do |w|
      if @all_answers[cntr].nil?
        w << 0
      else
        w << 1
      end
      cntr+=1
    end
    
    @best_friends = Array.new
    
    #Compare
    @who_participated.each do |p|
      if p[2] == 1
        @best_friends << p[0]
      end
    end
    
    #Count Occurances and sort
    counts = Hash.new 0
    @best_friends.each do |friend|
      counts[friend] += 1
    end
    
    @best_friends_sorted = counts.sort_by { |user_id, occurance| occurance }.reverse
   
    #logger = Logger.new('logfile.log')
    #logger.info "MMMMMMMMMMMMMMMMM"
  end
 
  def create
    @poll = Poll.new(poll_params)
    @poll.user_id = current_user.id
    if @poll.save
      c = Contribution.new
      c.user_id = current_user.id
      c.contribution_type = Chilivote::Application.config.contribution_type_poll
      c.parent_id = @poll.id
      c.save
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
  
  def show_answers
    @poll = Poll.find(params[:poll_id])
    @poll_votes = @poll.pvotes
     respond_to do |format|
        format.js
    end
  end
  
  def hide_answers
    @poll_id = params[:poll_id]
    respond_to do |format|
        format.js
    end
  end
 
  private
 
  def poll_params
    params.require(:poll).permit(:topic, vote_options_attributes: [:id, :title, :correct_answer, :_destroy])
  end
end
