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

When(/^I search for the status of an order with id '(.*)' that '(.*)'$/) do |order_id, error_state_description|
  case error_state_description
  when "doesnt exist"
    setup_fulfilment_service_stub_error(order_id, 404)
  when "timed out from fusion"
    setup_fulfilment_service_stub_error(order_id, 503)
  when "has an unexpected status"
    setup_fulfilment_service_stub_error(order_id, 500)
  else
    raise 'Unknown Error Scenario'
  end
  submit_track_form_with order_id
end

When(/^I search for the status of a valid order with id '(.*)'$/) do |order_id|
  setup_fulfilment_service_stub(order_id)
  submit_track_form_with order_id
end

Then(/^I should see the tracking status '(.*)' for the order$/) do |status_header|
  expect(page.find('.status-heading')).to have_content(status_header)
  steps %Q{
    Then I should see the Megamenu header
    Then I should see the Megamenu footer
  }
end

Then(/^I should see the right count and description for each item$/) do
  expected = ['1 x iPhone 5C 32GB magenta',
              '1 x Microsim \"G23123\"',
              'iPhone 5C 16GB Gold',
              "Microsim 'F2313'",
              "Soft leather case & screen protector <h1>&1234;_!|\\/#"]
  not_found = page.all('.order-details > .item').reject { |elem| expected.include?(elem.text) }
  expect(not_found).to be_empty
end

And(/^I should see the message '(.*)'$/) do |message|
  expect(page.find('.status-message')).to have_content(message)
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

def submit_track_form_with order_id
  within("#track-form") do
    fill_in 'tracking_id', :with => order_id
  end
  click_button 'Trace your order'
end


