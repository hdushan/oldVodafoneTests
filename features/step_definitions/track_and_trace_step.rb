When(/I navigate to '(.*)'/) do |url|
  visit url
  expect(page).to have_title "Track and trace"
end

When(/^I view status of an order '(.*)' that does not exist$/) do |order_id|
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

When(/^I view status of an order '(.*)' that exists$/) do |order_id|
  unless ENV['RAILS_ENV'] == 'paas-qa'
    ff_client = double('ff_client')
    FulfilmentServiceProviderClient.stub(:new).and_return ff_client
    ff_client.stub(:get_order_status).with(order_id) { "#{order_id} status: Complete" }
  end

  within(".track-form") do
    fill_in 'tracking_id', :with => order_id
  end
  click_button 'Trace your order'
end

Then(/^I should see the tracking status for the order '(.*)'$/) do |order_id|
  expect(page).to have_content(order_id)
  expect(page).to have_content('Complete')
end

Then(/^I should see the error message$/) do
  expect(page).to have_content('ORDER_NOT_FOUND')
end