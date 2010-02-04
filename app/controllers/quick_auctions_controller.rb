class QuickAuctionsController < ApplicationController
  
  def index
    @product = Product.find(459084718)
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
    @price = Price.find(params[:price_id])
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
