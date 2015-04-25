class SvotesController < ApplicationController
  before_action :set_svote, only: [:show, :edit, :update, :destroy]

  # GET /svotes
  # GET /svotes.json
  def index
    @svotes = Svote.all
  end

  # GET /svotes/1
  # GET /svotes/1.json
  def show
  end

  # GET /svotes/new
  def new
    @svote = Svote.new
  end

  # GET /svotes/1/edit
  def edit
  end

  # POST /svotes
  # POST /svotes.json
  def create
    @svote = Svote.new(svote_params)
    
    respond_to do |format|
      if @svote.save
        format.html { redirect_to @svote, notice: 'Svote was successfully created.' }
        format.json { render action: 'show', status: :created, location: @svote }
      else
        format.html { render action: 'new' }
        format.json { render json: @svote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /svotes/1
  # PATCH/PUT /svotes/1.json
  def update
    respond_to do |format|
      if @svote.update(svote_params)
        format.html { redirect_to @svote, notice: 'Svote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @svote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /svotes/1
  # DELETE /svotes/1.json
  def destroy
    @svote.destroy
    respond_to do |format|
      format.html { redirect_to svotes_url }
      format.json { head :no_content }
    end
  end
  
  def vote_status_up
    
    @svote = Svote.new
    @current_user = current_user
    @status_id = params[:id]
    
    @status = Status.find(@status_id)
    
    #managing hack attempts
    if @status.nil?
      redirect_to '/' and return
    end
    
    if !@current_user.friends.include?(@status.user)
      redirect_to '/' and return
    end
    
    #logger = Logger.new('logfile.log')
    #logger.info "GGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    #logger.info @current_user.id
    #logger.info @status_id
    if @current_user.voted_for_status?(@status_id)
      #logger.info "I am exiting"
      redirect_to '/' and return
    end      
    #end hack attempts

    @svote.user_id = @current_user.id
    @svote.status_id = @status_id
    @svote.svote_status = 2
    
    @svote.save
     respond_to do |format|
        format.js
    end
  end
  
  def vote_status_down
    
    @svote = Svote.new
    @current_user = current_user
    @status_id = params[:id]
    
    @status = Status.find(@status_id)
    
    #managing hack attempts
    if @status.nil?
      redirect_to '/' and return
    end
    
    if !@current_user.friends.include?(@status.user)
      redirect_to '/' and return
    end
    
    #logger = Logger.new('logfile.log')
    #logger.info "GGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    #logger.info @current_user.id
    #logger.info @status_id
    if @current_user.voted_for_status?(@status_id)
      #logger.info "I am exiting"
      redirect_to '/' and return
    end      
    #end hack attempts

    @svote.user_id = @current_user.id
    @svote.status_id = @status_id
    @svote.svote_status = 1
    
    @svote.save
     respond_to do |format|
        format.js
    end
  end
  
  def list_voters
    if params[:mode] == "up"
      @status_code = 2
    elsif params[:mode] == "down"
      @status_code = 1
    end
    respond_to do |format|
      @status_voters = Svote.find_all_by_status_id_and_svote_status(params[:status_id], @status_code)
        format.js
        format.html {render :nothing => true, :status => 200, :content_type => 'text/html'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_svote
      @svote = Svote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def svote_params
      params[:svote]
    end
end
