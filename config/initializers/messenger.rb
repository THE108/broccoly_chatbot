Messenger.configure do |config|
  config.verify_token      = ENV['MESSENGER_VERIFY_TOKEN']
  config.page_access_token = ENV['MESSENGER_PAGE_ACCESS_TOKEN']
end