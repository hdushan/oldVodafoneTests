Given(/^I am on the Track and Trace Home page '(.*)'$/) do |url|
  visit url
  expect(page).to have_field('tracking_id')
  steps %Q{
    Then I should see the Megamenu header
    Then I should see the Megamenu footer
  }
end

Given(/^I use a mobile device to visit the Track and Trace Home page '(.*)'$/) do |url|
  visit url
  expect(page).to have_field('tracking_id')
end

Then(/^I should see the mobile version of header and footer$/) do
  steps %Q{
    Then I should see the mobile Megamenu header
    Then I should see the mobile Megamenu footer
  }
end

When(/^I search for the status of an order with id '(.*)' that does not exist$/) do |order_id|
  setup_fulfilment_service_stub(order_id, FulfilmentResponse.new(404, {}) )
  submit_track_form_with order_id
end

When(/^I search for the status of a valid order with id '(.*)'$/) do |order_id|
  setup_fulfilment_service_stub(order_id, FulfilmentResponse.new(200, {"tracking_status" =>"CANCELLED"} ) )
  submit_track_form_with order_id
end

When(/^I search for the status of an order with id '(.*)' that timed out$/) do |order_id|
  setup_fulfilment_service_stub(order_id, FulfilmentResponse.new(503, {}) )
  submit_track_form_with order_id
end

Then(/^I should see the tracking status for the order '(.*)'$/) do |order_id|
  expect(page).to have_content('Your order has been cancelled')
  steps %Q{
    Then I should see the Megamenu header
    Then I should see the Megamenu footer
  }
end

Then(/^I should see a '(.*)' error message$/) do |error_message|
  expect(page).to have_content(error_message)
  steps %Q{
    Then I should see the Megamenu header
    Then I should see the Megamenu footer
  }
end

Then(/^I should see the Megamenu header$/) do
  expect(page).to have_content('Sign in to My Vodafone') #Megamenu Header
end

Then(/^I should see the Megamenu footer$/) do
  expect(page).to have_content('About this site') #Megamenu footer
end

Then(/^I should see the mobile Megamenu header$/) do
  expect(page).to have_content('Our best offers') #Mobile Megamenu Header
end

Then(/^I should see the mobile Megamenu footer$/) do
  expect(page).to have_content('Full site') #Mobile Megamenu footer
end

def setup_fulfilment_service_stub order_id, return_value
  unless ENV['RAILS_ENV'] == 'paas-qa'
    ff_client = Capybara.app.instance_variable_get("@instance").instance_variable_get("@fulfilment_client")
    ff_client.stub(:get_order_details).with(order_id) { return_value }
  end
end

def submit_track_form_with order_id
  within("#track-form") do
    fill_in 'tracking_id', :with => order_id
  end
  click_button 'Trace your order'
end


