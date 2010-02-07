class QuickAuctionsController < ApplicationController
  
  def index
    @product = Product.availables.last
  end
  
  def show
    @variant = Variant.find(params[:id])
  end
 
  def create
    variant = Product.find(params[:product_id].to_i).variants.find(params[:variant_id].to_i)
    if variant.in_stock?
      variant.update_attributes(:count_on_hand => 0)
    else
      variant.update_attributes(:count_on_hand => 1)
    end
    render :nothing => true
  end
  
  def checkout
    @variant = Variant.find(params[:id])
    @product = @variant.product
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
