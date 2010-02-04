require File.dirname(__FILE__) + '/../spec_helper'

describe ProductSize do
  before(:each) do
    @product_size = ProductSize.new
  end

  it "should be valid" do
    @product_size.should be_valid
  end
end
