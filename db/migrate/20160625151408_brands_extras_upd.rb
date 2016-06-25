class BrandsExtrasUpd < ActiveRecord::Migration
  def change
  	change_table :brands do |t|
      t.remove :type
      t.remove :style
      t.remove :price
      t.remove :music
      t.remove :mood
      t.remove :personality
  	end
  end
end
