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
    
    # AppConfiguration.class_eval do
    #   preference :stylesheets, :string, :default => 'style_hz'
    # end
    
    Product.class_eval do
      has_many :prices
      
      before_update :change_prices
      
      def change_prices
        if self.count_on_hand_changed?
          if self.count_on_hand != 0
            self.count_on_hand.times.each do |price|
              self.prices.create(:price => (price + 1) * self.step)
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
    
    # Admin::ProductsController.class_eval do
    #   before_filter :change_time, :only => :update
      
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
