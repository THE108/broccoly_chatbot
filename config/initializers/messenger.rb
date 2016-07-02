# unless Rails.env.production?
#   Dir["#{Rails.root}/app/bot/**/*.rb"].each { |file| require file }
# end
#
# Facebook::Messenger.configure do |config|
#   config.access_token = ENV['MESSENGER_PAGE_ACCESS_TOKEN']
#   config.app_secret = ENV['MESSENGER_APP_SECRET']
#   config.verify_token = ENV['MESSENGER_VERIFY_TOKEN']
# end