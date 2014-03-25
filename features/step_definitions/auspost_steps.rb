Then(/^I should see the AusPost status '(.*)' for the order$/) do |status_header|
  patiently_wait_until(15) { page.has_css?('#auspost-status') }
  expect(page.find('#auspost-status')).to have_content(status_header)
end

Then(/^I should see no AusPost status for the order$/) do
  expect(page).to have_no_selector('#auspost-status')
end

And(/^I should see the AusPost tracking number '(.*)'$/) do |auspost_number|
  expect(page).to have_selector('#auspost-number', text: auspost_number)
end

And(/^I should see a link to '(.*)' with text '(.*)'$/) do |href, text|
  expect(page).to have_link(text, href: href)
end

And(/^I should see the AusPost status message '(.*)'$/) do |message|
  patiently_wait_until(15) { page.has_css?('#auspost-msg') }
  expect(page.find('#auspost-msg')).to have_content(message)
end

Then(/^I should not see any shipping events$/) do
  expect(page).to have_no_selector('.events')
  expect(page).to_not have_content('Date/Time')
end

And(/^I should see the shipping events from AusPost$/) do
  expect(page).to have_selector('.tracking-info')
  expect(page.all('.event-date').map { |elem| elem.text }).to eq(['21/06/2010 12:21PM', '21/06/2010 12:12PM', '10/12/2008 12:12PM'])
  expect(page.all('.event-status').map { |elem| elem.text }).to eq(['Delivered', 'Redirected', 'Signed'])
end

And(/^I should see exactly (.*) shipping events from AusPost$/) do |number_of_events|
  expect(page).to have_selector('.tracking-info')
  expect(page.all('.event-date')).to have(number_of_events).items
end

Then(/^I should see multiple AusPost statuses$/) do
  patiently_wait_until(15) { page.has_css?('#auspost-status') }
  expect(page.all('#auspost-status').map { |elem| elem.text }).to eq(['Delivered', 'Accepted by Driver'])
end

