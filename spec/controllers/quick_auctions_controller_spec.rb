require File.dirname(__FILE__) + '/../spec_helper'

describe QuickAuctionsController do
  
  describe 'Test routes' do
    
    describe 'Test / path and routes' do
      it "should / must be quick_auction index" do
        root_path.should == '/'
        params_from(:get, '/').should == { :controller => 'quick_auctions', :action => 'index', :method => "get" }
        route_for(:controller => 'quick_auctions', :action => 'index', :method => 'get').should == '/'
      end
      it "should / must not work" do
        params_from(:post, '/').should_not == { :controller => 'quick_auctions', :action => 'index'}
        params_from(:delete, '/').should_not == { :controller => 'quick_auctions', :action => 'index'}
        params_from(:put, '/').should_not == { :controller => 'quick_auctions', :action => 'index'}
      end
    end
    
    describe 'Test /checkout path and routes' do
      it "should success with corrent options" do
        checkout_variant_path(:permalink => 'abcd').should == '/checkout/abcd'
        params_from(:get, '/checkout/abcd').should == { :controller => 'quick_auctions', 
                                                        :action => 'checkout', 
                                                        :method => "get",
                                                        :permalink => 'abcd'}
        route_for(:controller => 'quick_auctions', :action => 'checkout', 
                  :method => 'get', :permalink => 'abcd').should == '/checkout/abcd'
      end
      it "should / must not work" do
        params_from(:post, '/checkout/abcd').should_not == '/checkout/abcd'
        params_from(:delete, '/checkout/abcd').should_not == '/checkout/abcd'
        params_from(:put, '/checkout/abcd').should_not == '/checkout/abcd'
        params_from(:get, '/checkout/abcd').should_not == { :controller => 'quick_auctions', 
                                                            :action => 'checkout', 
                                                            :method => "get",
                                                            :permalink => 'bcda' }
      end
    end

    describe 'Test controller actions' do

      describe 'Check :controller => quick_auctions, :action => index' do
        def do_action
          get :index
        end
        
        it "should be success" do
          do_action
          response.should be_success
        end
        
        it "should cookies be nil" do
          do_action
          cookies[:selected_option].should be_nil
        end
        
      end 
      
      describe 'Check :controller => quick_auctions, :action => checkout. Wrong' do
        def do_action(permalink='abcd')
          get :checkout, :permalink => permalink
        end
        it "should be redirect" do
          do_action
          response.should be_redirect
        end 
        it "should be redirect to /" do
          do_action
          response.should redirect_to(root_path)
        end 
      end 
      
      describe 'Check :controller => quick_auctions, :action => checkout. Right' do
        before :each do
          @product = mock_model(Product, :permalink => 'test-1-2-3-q')
          @variant = mock_model(Variant, :product_id => @product.id)
          Product.stub(:find_by_permalink).and_return(@product)
          @product.stub(:variants).and_return([@variant])
          @variant.stub(:find).and_return(@variant)
          @variant.stub(:in_stock?).and_return(true)
        end
        
        def do_action(permalink=@product.permalink)
          get :checkout, :permalink => permalink
        end
        
        it "should be success" do
          do_action
          puts flash[:notice]
          response.should be_success
        end
        
        # it "should be not redirected" do
        #   do_action
        #   response.should_not be_redirect
        # end 
        
      end 
    
    
    end 

    
  end 

end
