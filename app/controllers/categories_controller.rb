class CategoriesController < ApplicationController

  before_filter :authenticate_user!, :init_app 
  before_filter :get_last_links
  before_filter :get_favorites_links
  
  def index
    
    @categories = Category.where(:user_id => current_user.id).paginate(:page => params['page'], :per_page => 20).order('name ASC')


  end

  def destroy

    @categories = Category.find_all_by_user_id(current_user.id)
  end

  def show

    @category = Category.find_by_id(params[:id])
    @links = Link.where(:category_id => params[:id]).order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def new

    @category = Category.new
  end

  def update

    @category = Category.find(params[:id])

    if @category.update_attributes params[:category]

      redirect_to categories_path, notice: 'Category has been saved'
    
    else

      render action: 'edit'
    end

  end

  def edit

    @category = Category.find(params[:id])

  end

  def destroy

    category = Category.find(params[:id])
    category.destroy
    redirect_to categories_path, :notice => "You destroyed a category"
  end

  def create

    @category = Category.new(params[:category][:category_id])
    @category.user_id = current_user.id
    @category.name = params[:category][:name]

    if @category.save

      redirect_to @category, notice: 'Category has been saved'
    else
      render action: 'new'
    end
  end

end
