class RenameBrandToColor < ActiveRecord::Migration
  def change
      rename_column :users, :brand, :color
  end
end
