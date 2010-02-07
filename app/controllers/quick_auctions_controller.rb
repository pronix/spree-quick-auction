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
    begin
      @variant = Product.find_by_permalink(params[:permalink]).variants.find(cookies[:selected_option])
    rescue
      flash[:notice] = "Sorry, but wrong product name"
      redirect_to ('/') and return
    end
    if @variant.nil? || !@variant.in_stock?
      flash[:notice] = "Sorry, but the lot has already been bought"
      redirect_to ('/') and return
    end
    @product = @variant.product
  end
  

end
