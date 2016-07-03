class OauthController < ApplicationController
  def authorize
    redirect_to params['redirect_uri'] + "&authorization_code=test"
  end
end
