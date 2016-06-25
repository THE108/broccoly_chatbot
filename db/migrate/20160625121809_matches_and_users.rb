class MatchesAndUsers < ActiveRecord::Migration
  def change
  	change_table :matches do |t|
      t.integer :user_id
      t.integer :brand_id
      t.boolean :match
  	end
  end
end
