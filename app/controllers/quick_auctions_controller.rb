class QuickAuctionsController < ApplicationController
  
  def index
    @product = Product.last
  end
  
  def show
    @variant = Variant.find(params[:id])
  end
 
  def create
    price = Product.find(params[:product_id].to_i).prices.find(params[:price_id].to_i)
    if price.sold
      price.update_attributes(:sold => false)
    else
      price.update_attributes(:sold => true)
    end
    render :nothing => true
  end
  
  def checkout
    @variant = Variant.find(params[:id])
  end
  
  # def update
  #   price = Product.find(params[:id].to_i).prices.find(params[:price_id].to_i)
  #   if price.sold
  #     price.update_attributes(:sold => false)
  #   else
  #     price.update_attributes(:sold => true)
  #   end
  #   redirect_to :back
  # end

end
