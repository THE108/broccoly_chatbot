class MessengerController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def webhook
    if params['hub.mode'] == 'subscribe' && params['hub.verify_token'] == ENV['MESSENGER_VERIFY_TOKEN']
      render text: params['hub.challenge'], status: 200
    else
      render nothing: true, status: 403
    end

  end
end