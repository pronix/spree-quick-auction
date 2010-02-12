class QuickAuctionExtension < Spree::Extension
  version "1.0"
  description "Quick Auction extension for spree"
  url "http://github.com/pronix/spree-quick-auction"

  def activate
    
    # ApplicationController.class_eval do
    #   before_filter :change_current_action
      
    #   def change_current_action
    #     @current_action = 'thank_you'
    #   end
    # end
    
    LineItem.class_eval do
      before_update :fix_quantity
      
      # Some hack. Becouse I don't know the reason why :quantity set to +1
      # if :quantity is not 0
      # TODO: try to kosher way to don't do this
      def fix_quantity
        self.quantity = 1
      end
      
    end
        
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
                                               Time.now.utc, Time.now.utc], :order => 'created_at DESC'
      
      def available?
        return true if self.available_on <= Time.now && self.available_off >= Time.now
      end
      
      class << self
        def available_last
          self.availables.map {|x| x if x.has_variants?}.compact.try(:first)
        end
      end
      
    end
    
    ProductsController.class_eval do
      before_filter :find_price, :only => :show
      before_filter :redirect_to_main, :only => :index
      
      # Basically redirect to / if user respone to /products
      # I think it's more nice, that dirty routes, but it still very stupid
      def redirect_to_main
        redirect_to root_path
      end
      
      def find_price
        @price = Price.find(params[:price_id])
        redirect_to root_path if @price.sold
      end
      
    end
    
    OrdersController.class_eval do
      before_filter :fix_type_values, :only => :create
      before_filter :check_variants, :only => :edit
      before_filter :remember_variant_options, :only => :create
      
      # When user click to Buy Now we redirect he to checkout edit page
      create do
        flash nil 
		success.wants.html {redirect_to order_checkout_path(@order)}
		failure.wants.html {redirect_to root_path}
      end
      
      # This staff save variants choices in session and don't change
      # a variant
      def remember_variant_options
        # some precautions if params[:products] is ''
        return if params[:products].blank?
        # If it's a new session we simple add varinat to it
        if session[:products].blank?
          session[:products] = [ { :variant_id => params[:products][:variant_id],
                                   :sex => params[:sex],
                                   :size => params[:size] } 
                               ]
        else
          # Check, if session have this variant, but other options
          session[:products].each_with_index do |variant, index|
            session[:products].delete_at(index) if params[:products][:variant_id] == variant[:variant_id]
          end
          session[:products] << { :variant_id => params[:products][:variant_id],
            :sex => params[:sex],
            :size => params[:size]
          }
        end
      end
            
      
      def fix_type_values
        # variant = Variant.find(params[:products][:variant_id])
        # variant.option_values.clear
        # variant.product.option_types.map {|option| option.name}.each do |option_name|
        #   if params.key?(option_name)
        #     variant.option_values << OptionValue.find(params[option_name.to_sym])
        #   end
        # end
        # debugger
        params.merge!({:quantity => "1"})
      end
      
      def check_variants
        order = Order.find_by_token(session[:order_token])
        order.line_items.each do |line_item|
          if !line_item.variant.in_stock? || !line_item.variant.product.available?
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
    
    Spree::BaseHelper.class_eval do
      def variant_options_session(variant, user_session = [])
        user_session.map do |x|
          if x[:variant_id].to_i == variant.id
            return "Size: #{OptionValue.find(x[:size].to_i).presentation}, Sex: #{OptionValue.find(x[:sex].to_i).presentation}<br />"
          end
        end
      end
    end

  end
    
end
