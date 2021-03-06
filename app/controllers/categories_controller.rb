class CategoriesController < ApplicationController
  include SessionsHelper
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:create, :new, :edit, :update, :destroy, :index]


  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end
  
  def list_categories
   if !signed_in? 
     redirect_to "/"
   end
   @categories = Category.find_all_by_active(true, :limit => 8);
   @categories_counter = 1;
   
   @admin_user = User.find_by_email("admin@chilivote.com")
   @life_votes = @admin_user.cvotes.order(created_at: :desc).limit(3)
   @logged_in_user = current_user
  end
  
  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    if params[:image_id].present?
      preloaded = Cloudinary::PreloadedFile.new(params[:image_id])         
      raise "Invalid upload signature" if !preloaded.valid?
      @category.image_id = preloaded.identifier
    end
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    #logger = Logger.new('logfile.log')
    #logger.info "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
    #logger.info params[:id]
    #logger.info params[:category][:name]
    #logger.info params[:category][:description]
    #logger.info params[:category][:image_id]
    #logger.info params[:image_id]

    
    @category = Category.find(params[:id])
    @category.name = params[:category][:name]
    @category.description = params[:category][:description]
    preloaded = Cloudinary::PreloadedFile.new(params[:image_id])         
    raise "Invalid upload signature" if !preloaded.valid?
    @category.image_id = preloaded.identifier
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :description, :active, :image_id)
    end
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    
     def admin_user
        if !signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
        else
        redirect_to '/' unless current_user.admin?
        end
    end
end
