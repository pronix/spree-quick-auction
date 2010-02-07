map.change_price '/change_price', :controller => "quick_auctions", :action => "create"
map.checkout_variant '/checkout/:id', :controller => "quick_auctions", :action => "checkout"
map.resources :quick_auctions
map.root :controller => "quick_auctions", :action => "index"
