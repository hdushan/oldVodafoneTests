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
    when "fusion thinks is invalid"
      setup_fulfilment_service_stub_error(order_id, 400)
    when "doesnt exist"
      setup_fulfilment_service_stub_error(order_id, 404)
    when "causes a generic system fault in fusion"
      setup_fulfilment_service_stub_error(order_id, 503)
    when "timed out from fusion"
      setup_fulfilment_service_stub_error(order_id, 503)
    when "has an unexpected status"
      setup_fulfilment_service_stub_error(order_id, 500)
    else
      raise 'Unknown Error Scenario'
  end
  submit_track_form_with order_id
end

When(/^I search for the status of a valid order with id '(.*)'/) do |order_id|
  setup_fulfilment_service_stub(order_id)
  submit_track_form_with order_id
end

Then(/^I should see the tracking status '(.*)' for the order$/) do |status_header|
  expect(page.find('#vodafone-status')).to have_content(status_header)
  steps %Q{
    Then I should see the Megamenu header
    Then I should see the Megamenu footer
  }
end

Then(/^I should see tracking statuses '(.*)' and '(.*) for the order$/) do |status1, status2|
  status_headings = page.all('#vodafone-status')
  expect(status_headings.count).to be(2)
  expect(status_headings.first.text).to eq(status1)
  expect(status_headings.last.text).to eq(status2)
end

Then(/^I should see the right count and description for each item$/) do
  expected_descriptions = ['iPhone 5C 32GB magenta',
    'Microsim "G23123"',
    'iPhone 5C 16GB Gold',
    "Microsim 'F2313'",
    "Soft leather case & screen protector <h1>&1234;_!|\\/#"]
  actual = page.all('.item').map { |elem| elem.text }
  expect(actual).to match_array expected_descriptions
  expected_counts = ['1 x', '1 x', '1 x', "1 x", "2 x"]
  actual_counts = page.all('.item-quantity').map { |elem| elem.text }
  expect(actual_counts).to match_array expected_counts
end

Then(/^I should see the right count, description and status for each item$/) do
  expected_descriptions = ['iPhone 5C 16GB Blue',
    'iPhone 5C 16GB Gold',
    'iPhone 5C 16GB Silver',
    "iPhone 5C 16GB Grey"]
  actual = page.all('.item').map { |elem| elem.text }
  expect(actual).to match_array expected_descriptions
  expected_counts = ['1 x', '2 x', '3 x', "4 x"]
  actual_counts = page.all('.item-quantity').map { |elem| elem.text }
  expect(actual_counts).to match_array expected_counts
  expected_statuses = ['Cancelled.',
    'Shipped.',
    'Cancelled.',
    'Shipped.']
  actual_statuses = page.all('.item-status').map { |elem| elem.text }
  expect(actual_statuses).to match_array expected_statuses
end


Then(/^I should see an item with '(.*)' and '(.*)' for the order$/) do |num, item_status|
  unless num == 'na' && item_status == 'na'
    all_items = page.all('.item-row')
    found = all_items.inject(false) do |item_found, item_row|
      item_found = item_found || item_row.find('.item-quantity').text == num && item_row.find('.item-status').text == item_status
      item_found
    end
    expect(found).to be_true
  end
end

Then(/^I should see the estimated shipping date for the order$/) do
  expect(page.find('.ship-date')).to have_content('31 December 2014')
end

And(/^I should see the message '(.*)'$/) do |message|
  if message.empty?
    expect(page).to have_no_selector('.status-message')
  else
    expect(page.find('.status-message')).to have_content(message)
  end
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
  click_button 'Track your order'
end
