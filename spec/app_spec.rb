require 'spec_helper'

describe "Track & Trace App" do

  it "should respond to GET" do
    get '/'
    last_response.should be_ok
    last_response.should match /Text from haml/
  end

end