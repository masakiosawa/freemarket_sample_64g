class ItemsController < ApplicationController

  before_action :set_item, only: [:index, :show, :edit, :destroy, :buyscreen,]
  def index
    @items = Item.find(set_item[:id]).limit(10).order('created_at DESC')
    @images = Image.find(set_item[:id])
    @image = Image.find(item_id: image_params)
    @item = Item.find(set_item[:id])
    @item.update( buyer_id: current_user.id)
  end
  def show
    @category = Category.find(params[:id])
    @images = Image.where(item_id:@item.id)
    @image = @images
    @brand = Brand.find(params[:id])
  end
  def buyscreen
    @images = Image.where(item_id:@item.id)
    @image = @images[0]
    @addresses = Address.where(user_id: current_user.id)
    @address = @addresses[0]
    @item.buyer_id = current_user.id
    @item.save
    card = Card.find_by(user_id: current_user.id)
    if card.blank?
      redirect_to action: "new" 
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end
  def buyscreenitem
    @item = Item.find(set_item[:id])
    @item.update( buyer_id: current_user.id)
  end
  def edit
    @item = Item.find(1)
  end
  def destroy
    if @item.user_id == current_user.id && @item.destroy
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
  