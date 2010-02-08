class QuickAuctionExtension < Spree::Extension
  version "1.0"
  description "Quick Auction extension for spree"
  url "http://github.com/pronix/spree-quick-auction"

  def activate
    
    Product.class_eval do
      
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
      
      
      named_scope :availables, :conditions => ['available_on <= ? AND available_off >= ?',
                                               Time.now.utc, Time.now.utc]
      
      def available?
        return true if self.available_on <= Time.now && self.available_off >= Time.zone.now
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
      before_filter :fix_on_hand, :only => :update
      
      def fix_on_hand
        params[:product].delete(:on_hand) if !Product.find_by_permalink(params[:id]).variants.blank?
      end
      
      # Set it before_filter, coz we have error hand_on
      def change_prices
        @product.change_variants if @product.variants.blank?
      end
      
    end

  end
    
end
