class RenameBrandTableToItem < ActiveRecord::Migration
  def change
      rename_table :brands, :items
      drop_table :brand_options
      remove_column :items, :facebook_id
      add_column :items, :picture_URL, :string
      add_column :items, :price, :integer
      add_column :items, :brand, :string
      add_column :items, :platform, :string
      add_column :items, :camera, :string
      add_column :items, :price_category, :string
      add_column :items, :sim_count, :string
      add_column :items, :cpu_category, :string
  end
end
