class RemoveOptionsFromUser < ActiveRecord::Migration
  def change
      remove_column :items, :brand, :string
      remove_column :items, :platform, :string
      remove_column :items, :camera, :string
      remove_column :items, :price_category, :string
      remove_column :items, :sim_count, :string
      remove_column :items, :cpu_category, :string
  end
end
