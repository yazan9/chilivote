class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy, :report_contribution]

  # GET /contributions
  # GET /contributions.json
  def index
    @contributions = Contribution.all
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
  end

  # GET /contributions/new
  def new
    @contribution = Contribution.new
  end

  # GET /contributions/1/edit
  def edit
  end

  # POST /contributions
  # POST /contributions.json
  def create
    @contribution = Contribution.new(contribution_params)

    respond_to do |format|
      if @contribution.save
        #add a notification to my friends
        current_user.friends.each do |my_friend|
          n = Notification.new
          n.notification_type = 3
          n.user_me = my_friend.id
          n.user_friend = current_user.id
          n.target_id = @contribution.id
          n.save
        format.html { redirect_to @contribution, notice: 'Contribution was successfully created.' }
        format.json { render action: 'show', status: :created, location: @contribution }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to @contribution, notice: 'Contribution was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    if @contribution.user.id == current_user.id
      @likes =  @contribution.likes
      @comments = @contribution.comments
      @options = @contribution.options
      @likes.destroy_all
      @comments.destroy_all
      @options.each do |option|
        option.destroy
      end
      @contribution.destroy!
    end
    
    respond_to do |format|
      #format.html { head :no_content }
      format.js
    end
  end
  
  def report_contribution
    respond_to do |format|
      #format.html { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      params[:contribution]
    end
end
