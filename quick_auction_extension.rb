# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class QuickAuctionExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/quick_auction"

  # Please use quick_auction/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate
    
    Product.class_eval do
      # has_many :prices
      # has_many :product_sizes
      
      # before_create :change_prices
      
      def change_variants
        if self.count_on_hand != 0
          counts = self.count_on_hand
          counts.times.each do |price|
            variant = self.variants.create(:sku => self.sku + '_' + price.to_s,
                                           :price => self.price + (price + 1 - 1) * self.step,
                                           :count_on_hand => 1)
            self.option_types.each do |option_type|
              variant.option_values << option_type.option_values.last
            end
          end
        end
      end
      
      def available_on=(orig_date)
        write_attribute(:available_on, orig_date)
      end
      
      def available_off=(orig_date)
        write_attribute(:available_off, orig_date)
      end
      
    end
    
    ProductsController.class_eval do
      before_filter :find_price, :only => :show
      
      def find_price
        @price = Price.find(params[:price_id])
        redirect_to root_path if @price.sold
      end
      
    end
    
    OrdersController.class_eval do
      before_filter :fix_type_values, :only => :create
      after_filter :fix_quantity, :only => :create
      before_filter :check_variants, :only => :edit
      
      def fix_type_values
        variant = Variant.find(params[:products][:variant_id])
        variant.option_values.clear
        variant.product.option_types.map {|option| option.name}.each do |option_name|
          if params.key?(option_name)
            variant.option_values << OptionValue.find(params[option_name.to_sym])
          end
        end
        params.merge!({:quantity => 1})
      end
      
      # Dirty hack, but when add new variant to cart, quanity => 2
      def fix_quantity
        order = Order.find_by_token(session[:order_token])
        order.line_items.each do |line_item|
          line_item.update_attributes(:quantity => 1)
        end
        # Update order total, need when we use this hack
        order.update_totals!
      end
      
      def check_variants
        order = Order.find_by_token(session[:order_token])
        order.line_items.each do |line_item|
          unless line_item.variant.in_stock?
            order.line_items.delete(line_item)
          end
        end
      end
      
    end
    
    Admin::ProductsController.class_eval do
      after_filter :change_prices, :only => :update
      
      def change_prices
        @product.change_variants
      end
      
    end
      
    #   def change_time
    #     params[:product][:available_off] = Time.parse(params[:product][:available_off]) - 5.hours
    #     # product = Product.find_by_name(params[:product][:name])
    #     # product.update_attributes(:available_off => params[:product][:available_off])
    #     # Rails.logger.info [" [ zaebalo: ] ", product.try(:id)].join
    #     # params[:product][:available_off] = Time.parse(params[:product][:available_off]).to_s(:db)
    #     # params[:product][:available_on] = Time.parse(params[:product][:available_on]).to_s(:db)
    #     # if params[:product]
    #     #   params[:product][:available_off] = Time.parse(params[:product][:available_off]) if !params[:product][:available_off].blank?
    #     # end
    #      # Rails.logger.info [" [ Dwnload file: ] ", params[:product][:available_off]].join
    #   end
    # end
    
    # Admin::ProductsController.class_eval do
    #   before_filter :add_parts_tab
    #   def add_parts_tab
    #     @product << { :name => "HELLLOO", :url => "" }
    #   end
    # end

    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
  end
    
end
