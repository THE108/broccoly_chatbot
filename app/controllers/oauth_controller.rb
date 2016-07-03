class OauthController < ApplicationController
  before_action :require_login

  def authorize
    auth_code = "test_#{current_user.id}"
    current_user.update(
      account_linking_token: params['account_linking_token'],
      auth_code: auth_code
    )
    redirect_to params['redirect_uri'] + "&authorization_code=#{auth_code}"
  end
end
