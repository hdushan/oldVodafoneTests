Given(/^I am on the Track and Trace Home page '(.*)'$/) do |url|
  visit url
end

When(/^I search for the status of an order with id '(.*)' that does not exist$/) do |order_id|
  setup_fulfulment_service_stub(order_id, {'error' => "ORDER_NOT_FOUND"} )
  submit_track_form_with order_id
end

When(/^I search for the status of a valid order with id '(.*)'$/) do |order_id|
  setup_fulfulment_service_stub(order_id, {'status' => "Complete", 'email' => 'valid@example.com'} )
  submit_track_form_with order_id
end

When(/^I search for the status of an order with id '(.*)' that timed out$/) do |order_id|
  setup_fulfulment_service_stub(order_id, {'error' => "FUSION_TIMEOUT"} )
  submit_track_form_with order_id
end

When(/^I click on the link to see order details$/) do
  click_link 'Click here to see your order details'
end

Then(/^I should see the tracking status for the order '(.*)'$/) do |order_id|
  expect(page).to have_content('Complete')
end

Then(/^I should see a '(.*)' error message$/) do |error_message|
  expect(page).to have_content(error_message)
end

Then(/^I should see the authentication form$/) do
  expect(page).to have_css("form#auth-form")
end

Then(/^the order id is not editable$/) do
  find('form#auth-form input#tracking_id').disabled?.should be_true
end

Then(/^I am asked to authenticate by providing my email address$/) do
  find('form#auth-form input#email').disabled?.should be_false
  expect(page).to have_no_css("#date-of-birth")
end

def setup_fulfulment_service_stub order_id, return_value
  unless ENV['RAILS_ENV'] == 'paas-qa'
    ff_client = double('ff_client')
    FulfilmentServiceProviderClient.stub(:new).and_return ff_client
    ff_client.stub(:get_order_status).with(order_id) { return_value }
  end
end

def submit_track_form_with order_id
  within("#track-form") do
    fill_in 'tracking_id', :with => order_id
  end
  click_button 'Trace your order'
end