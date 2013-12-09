Given(/^I am on the Track and Trace Home page '(.*)'$/) do |url|
  visit url
  expect(page).to have_title "Track and trace"
end

When(/^I search for the status of an order with id '(.*)' that does not exist$/) do |order_id|
  unless ENV['RAILS_ENV'] == 'paas-qa'
    ff_client = double('ff_client')
    FulfilmentServiceProviderClient.stub(:new).and_return ff_client
    ff_client.stub(:get_order_status).with(order_id) { "ORDER_NOT_FOUND" }
  end

  within(".track-form") do
    fill_in 'tracking_id', :with => order_id
  end
  click_button 'Trace your order'
end

When(/^I search for the status of a valid order with id '(.*)'$/) do |order_id|
  unless ENV['RAILS_ENV'] == 'paas-qa'
    ff_client = double('ff_client')
    FulfilmentServiceProviderClient.stub(:new).and_return ff_client
    ff_client.stub(:get_order_status).with(order_id) { "status: Complete" }
  end

  within(".track-form") do
    fill_in 'tracking_id', :with => order_id
  end
  click_button 'Trace your order'
end

Then(/^I should see the tracking status for the order '(.*)'$/) do |order_id|
  expect(page).to have_content('Complete')
end

Then(/^I should see an error message that the order could not be found$/) do
  expect(page).to have_content('ORDER_NOT_FOUND')
end