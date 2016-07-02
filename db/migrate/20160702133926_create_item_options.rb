class CreateItemOptions < ActiveRecord::Migration
  def change
      create_table :item_options do |t|
        t.integer :item_id
        t.string :key
        t.string :value

        t.timestamps null: false
      end
  end
end
