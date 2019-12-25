class ItemsController < ApplicationController

  before_action :set_item, only: [:index, :show, :edit, :destroy]
  def index
    @items = Item.find(set_item[:id]).limit(10).order('created_at DESC')
    @images = Image.find(set_item[:id])
    @image = Image.find(item_id: image_params)
  end
  def show
    @category = Category.find(params[:id])
    @images = Image.where(item_id:@item.id)
    @image = @images
    @brand = Brand.find(params[:id])
    @user = User.find(params[:id])
  end
  def edit
    @item = Item.find(1)
  end
  def destroy
    if @item.seler_id == current_user.id && @item.destroy
      redirect_to mypage_index_path
    else
      redirect_to edit_item_path
    end
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def image_params
    @image = Image.find(params[:id])
  end
end
  