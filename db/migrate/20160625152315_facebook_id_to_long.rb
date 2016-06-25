class FacebookIdToLong < ActiveRecord::Migration
  def change
  	change_column :brands, :facebook_id, :bigint
  end
end
