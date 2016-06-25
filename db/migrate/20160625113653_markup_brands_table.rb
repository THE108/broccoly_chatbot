class MarkupBrandsTable < ActiveRecord::Migration
  def change
    create_table :brands do |t|

      t.timestamps null: false
    end
  	add_column :brands, :facebook_id, :integer
  	add_column :brands, :name, :string
  	add_column :brands, :page_URL, :string
  	
    add_column :brands, :gender, :integer
    add_column :brands, :type, :integer
    add_column :brands, :style, :integer
    add_column :brands, :price, :integer
    add_column :brands, :music, :integer
    add_column :brands, :mood, :integer
    add_column :brands, :personality, :integer
  end
end
# No fucks given about DRY ikr
