class OauthController < ApplicationController
  def authorize
    redirect_to params['redirect_uri'] + "&auth_code=test"
  end
end
