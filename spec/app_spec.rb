require 'spec_helper'

describe "Track & Trace App" do

  it "should respond to GET" do
    get '/tnt'
    last_response.should be_ok
    last_response.should match /Tracking number/i
  end

end