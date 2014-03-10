

def setup_fulfilment_service_stub order_id
  unless ENV['RAILS_ENV'] == 'paas-qa'
    stub_request(:get, FULFILMENT_ROOT)
      .to_return(:body => {
        _links:  {
            self: {
                href: "#{FULFILMENT_ROOT}"
            },
            order: {
                href: "#{FULFILMENT_ROOT}/order/{id}",
                templated: true
            }
        }}.to_json,
               :headers => {"Content-Type" => "application/json"},
               :code => 200)

    stub_request(:get, "#{FULFILMENT_ROOT}/order/#{order_id}")
      .to_return(:body => File.read("./features/fixtures/#{order_id}.json"),
               :headers => {"Content-Type" => "application/json"})

  end
end

def setup_fulfilment_service_stub_error order_id, status_code
  unless ENV['RAILS_ENV'] == 'paas-qa'
    stub_request(:get, "#{FULFILMENT_ROOT}/order/#{order_id}")
      .to_return(:headers => {"Content-Type" => "application/json"},
               :status => status_code)
  end
end

def stub_mega_menu
  stub_request(:get, "https://www.vodafone.com.au/rest/SharedContent?name:contains=Mega_MenuV2").
      to_return(:status => 200, :body => File.read('spec/fixtures/mega_header'), :headers => {})
  stub_request(:get, "https://www.vodafone.com.au/rest/SharedContent?name:contains=Footer").
      to_return(:status => 200, :body => File.read('spec/fixtures/mega_footer'), :headers => {})
  stub_request(:get, "https://www.vodafone.com.au/rest/SharedContent?name:contains=MobileMenu").
      to_return(:status => 200, :body =>  File.read('spec/fixtures/mobile_header'), :headers => {})
  stub_request(:get, "https://www.vodafone.com.au/rest/SharedContent?name:contains=MobileFooter").
      to_return(:status => 200, :body => File.read('spec/fixtures/mobile_footer'), :headers => {})
end