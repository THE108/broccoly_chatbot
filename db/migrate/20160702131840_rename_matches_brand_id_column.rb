class RenameMatchesBrandIdColumn < ActiveRecord::Migration
  def change
      rename_column :matches, :brand_id, :item_id
  end
end
