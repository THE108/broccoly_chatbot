class AddLatAndLongToUsers < ActiveRecord::Migration
  def change
    add_column :fb_users, :lat, :float
    add_column :fb_users, :long, :float
  end
end
