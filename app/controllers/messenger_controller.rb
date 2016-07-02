class MessengerController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def webhook
    render nothing: true, status: 200
  end
end