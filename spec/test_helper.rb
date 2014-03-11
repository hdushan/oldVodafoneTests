def mega_menu_mock
  mega_menu_client = double('MegaMenuAPIClient')
  mega_menu_client.stub(:get_menu).with(any_args) do
    { 'desktop' => MegaMenuAPIClient.empty_response, 'mobile' => MegaMenuAPIClient.empty_response }
  end
  mega_menu_client
end