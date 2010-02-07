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
        
      end 
      
    end 

    
  end 

end
