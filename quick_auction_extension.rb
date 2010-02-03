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
      
      # after_create :add_prices

      # def add_prices
      #   return if self.count_on_hand == 0
      #   count_on_hand.times.each do |price|
      #     self.prices.create(:price => (price + 1) * self.step)
      #   end
      # end
      
    end
    
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
