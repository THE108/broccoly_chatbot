class BrandsExtras < ActiveRecord::Migration
  def change
  	change_table :brands do |t|
  	  t.remove :gender
  	end
  end
end
