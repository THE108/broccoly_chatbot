class RenameUsersOptions < ActiveRecord::Migration
  def change
      remove_column :users, :piece
      remove_column :users, :style
      remove_column :users, :price
      remove_column :users, :music
      remove_column :users, :mood
      remove_column :users, :personality
      add_column :users, :brand, :string
      add_column :users, :platform, :string
      add_column :users, :camera, :string
      add_column :users, :price_category, :string
      add_column :users, :sim_count, :string
      add_column :users, :cpu_category, :string
  end
end
