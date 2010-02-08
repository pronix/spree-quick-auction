= Quick Auction

This is quick auction module for spree(tested on spree-0.9.4)

Step to install:
* script/extension install git@github.com:pronix/spree-quick-auction.git
* rake db:migrate

For load basic fixuters for t-shirt do this:
* rake spree:extensions:quick_auction:load_test_data

Run spree:
* ./script/server
* Go to http://localhost:3000/admin/products 
* Create a new product and fill all field. Must fill a prototype.
* Then edit the product and fill 'Available On', 'Available Off', 'On hand',
  Step and click update.
  Available On - this is date, when product is start to see in http://localhost:3000/
  Available Off - this is end date.
  On hand - this is count of prices(lots)
  Step - +1 cost to product.
  For example: we create a product with on hand - 50 nad step 1, and we obtain 50 prices,
  of one product wiht lowest price is 1 and highest price is 50.
* Now we can go to the main page(http://localhost:3000/) and see this product.

Notes:
* If afministrator want to reset on_hand values, he must destroy all variants on product.
* If product have a variants, administrator can see a table with prices, he can check and
  uncheck some price(simply clicking to price)
* User can store in his Shopping cart a lot of items, but if items already sell(with another user), we delete it item
  from user shop.
* All checkout process is standart, we sell not product, we sell only variants of product
* In main page we display lastest product with valid available_on and available_off date
* If administrator want to close some product, he must change availbale_off data less than available_on

