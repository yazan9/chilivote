class PostsController < ApplicationController
  include SessionsHelper
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:create, :new]
  before_action :admin_user, only: [:index, :activate, :deactivate]
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to '/'
  end

  # GET /posts
  # GET /posts.json
  def index
    #params[:mode] = 1. show all, 2. show active, 3. show inactive
    case params[:mode]
    when '1'
      @posts = Post.paginate page: params[:page], :per_page => 10
    when '2'
      @posts = Post.paginate page: params[:page], :per_page => 10, :conditions => ["active = ?", true]
    when '3'
      @posts = Post.paginate page: params[:page], :per_page => 10, :conditions => ["active = ?", false]
    else
      @posts = Post.paginate page: params[:page], :per_page => 10
    end
  end
  
  def activate
    @post = Post.find(params[:id])
    @post.active = true
    @post.save
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def deactivate
    @post = Post.find(params[:id])
    @post.active = false
    @post.save
    
    respond_to do |format|
      format.html
      format.js 
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new
    @post.category_id = params[:post][:category_id]
    if params[:image_id].present?
      preloaded = Cloudinary::PreloadedFile.new(params[:image_id])         
      raise "Invalid upload signature" if !preloaded.valid?
      @post.image_id = preloaded.identifier
    end
    @post.active = true
    @post.user_id = current_user.id
    #@post = current_user.posts.build

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  
  #attention: this function takes category_id as a parameter
  def view_posts
    #@posts = Post.find_by_category_id_and_active(params[:id], true)
    return redirect_to '/' if params[:id].nil?
    @posts = Category.find(params[:id]).posts
  end
  
  def next
    @post = Post.find(params[:next_photo])
    puts @post.image_id
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end
  
  def previous
    @post = Post.find(params[:previous_photo])
    puts @post.image_id
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end
  
  def vote
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
      puts params[:view_by]
      if params[:view_by] == "recent"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      #params.require(:post)
    end
    
    def signed_in_user
      unless signed_in?
        #store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    
     def admin_user
        if !signed_in?
        #store_location
        redirect_to signin_url, notice: "Please sign in."
        else
        redirect_to '/' unless current_user.admin?
        end
    end
end
