Given(/^I am on the authentication with email page with order id '(.*)'$/) do |order_id|
  visit "/auth?order_id=#{order_id}&authType=email"
end

When(/^I enter email '(.*)'$/) do |email|
  within("#auth-form") do
    fill_in 'email', :with => email
  end
  click_button 'Trace your order'
end
