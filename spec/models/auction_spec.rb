require File.dirname(__FILE__) + '/../spec_helper'

describe Auction do
  before(:each) do
    @auction = Auction.new
  end

  it "should be valid" do
    @auction.should be_valid
  end
end
