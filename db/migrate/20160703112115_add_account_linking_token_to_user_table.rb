class AddAccountLinkingTokenToUserTable < ActiveRecord::Migration
  def change
    add_column :users, :account_linking_token, :string
  end
end
