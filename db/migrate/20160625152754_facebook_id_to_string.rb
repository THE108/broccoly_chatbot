class FacebookIdToString < ActiveRecord::Migration
  def change
  	change_column :brands, :facebook_id, :string
  end
end
