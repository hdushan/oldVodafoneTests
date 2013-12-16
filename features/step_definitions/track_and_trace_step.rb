Given(/^I am on the Track and Trace Home page '(.*)'$/) do |url|
  visit url
end

When(/^I search for the status of an order with id '(.*)' that does not exist$/) do |order_id|
  setup_fulfulment_service_stub(order_id, {'error' => "ORDER_NOT_FOUND"} )
  submit_track_form_with order_id
end

When(/^I search for the status of a valid order with id '(.*)'$/) do |order_id|
  setup_fulfulment_service_stub(order_id, {'status' => "Complete"} )
  submit_track_form_with order_id
end

When(/^I search for the status of an order with id '(.*)' that timed out$/) do |order_id|
  setup_fulfulment_service_stub(order_id, {'error' => "FUSION_TIMEOUT"} )
  submit_track_form_with order_id
end

Then(/^I should see the tracking status for the order '(.*)'$/) do |order_id|
  expect(page).to have_content('Complete')
end

Then(/^I should see a '(.*)' error message$/) do |error_message|
  expect(page).to have_content(error_message)
end

def setup_fulfulment_service_stub order_id, return_value
  unless ENV['RAILS_ENV'] == 'paas-qa'
    ff_client = double('ff_client')
    FulfilmentServiceProviderClient.stub(:new).and_return ff_client
    ff_client.stub(:get_order_status).with(order_id) { return_value }
  end
end

def submit_track_form_with order_id
  within(".track-form") do
    fill_in 'tracking_id', :with => order_id
  end
  click_button 'Trace your order'
end