class RenameUsersToFbUsers < ActiveRecord::Migration
  def change
    rename_table :users, :fb_users
  end
end
