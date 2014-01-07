def mega_menu_mock
  mega_menu_client = double('MegaMenuAPIClient')
  mega_menu_client.stub(:get_menu).with(any_args) { MegaMenuAPIClient.empty_response }
  mega_menu_client
end