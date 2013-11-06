When(/I navigate to '(.*)'/) do |url|
  visit url
end

Then(/^I see the Track and Trace landing page$/) do
  expect(page).to have_title "Track and trace"
end