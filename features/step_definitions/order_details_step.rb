Given(/^I am on the (.*) authentication page with order id '(.*)'$/) do |auth_type, order_id|
  visit "/auth?order_id=#{order_id}&authType=#{auth_type}"
end

When(/^I enter email '(.*)'$/) do |email|
  within("#auth-form") do
    fill_in 'email', :with => email
  end
  click_button 'Trace your order'
end

When(/^I enter dob '(.*)'$/) do |dob|
  within("#auth-form") do
    fill_in 'date-of-birth', :with => dob
  end
  click_button 'Trace your order'
end

