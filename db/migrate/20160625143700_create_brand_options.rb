class CreateBrandOptions < ActiveRecord::Migration
  def change
    create_table :brand_options do |t|
      t.integer :brand_id
      t.string :key
      t.string :value

      t.timestamps null: false
    end
  end
end
