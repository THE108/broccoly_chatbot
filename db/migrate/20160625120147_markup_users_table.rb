class MarkupUsersTable < ActiveRecord::Migration
  def change
  	add_column :users, :facebook_id, :integer
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	
  	add_column :users, :gender, :integer
  	add_column :users, :type, :integer
  	add_column :users, :style, :integer
  	add_column :users, :price, :integer
  	add_column :users, :music, :integer
  	add_column :users, :mood, :integer
  	add_column :users, :personality, :integer
  end
end
# No fucks given about DRY ikr
