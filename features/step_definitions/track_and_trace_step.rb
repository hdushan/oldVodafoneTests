When(/I navigate to '(.*)'/) do |url|
  visit url
end

Then(/^I can see the Track and Trace landing page$/) do
  expect(page).to have_title "Track and trace"
end

When(/^I submit track form with wrong tracking id$/) do
  tracking_id = 'WRONG_ID'

  unless ENV['RACK_ENV'] == 'pass-qa'
    ff_client = double('ff_client')
    FulfilmentServiceProviderClient.stub(:new).and_return ff_client
    ff_client.stub(:get_order_status).with(tracking_id) { "ORDER_NOT_FOUND" }
  end

  within(".track-form") do
    fill_in 'tracking_id', :with => tracking_id
  end
  click_button 'Trace your order'
end

When(/^I submit track form with correct tracking id$/) do
  tracking_id = 'CORRECT_ID'

  unless ENV['RACK_ENV'] == 'pass-qa'
    ff_client = double('ff_client')
    FulfilmentServiceProviderClient.stub(:new).and_return ff_client
    ff_client.stub(:get_order_status).with(tracking_id) { 'Complete' }
  end

  within(".track-form") do
    fill_in 'tracking_id', :with => tracking_id
  end
  click_button 'Trace your order'
end

Then(/^I should see the tracking status$/) do
  expect(page).to have_content('Complete')
end

Then(/^I should see the error message$/) do
  expect(page).to have_content('ORDER_NOT_FOUND')
end