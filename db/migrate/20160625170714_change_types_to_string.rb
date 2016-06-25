class ChangeTypesToString < ActiveRecord::Migration
  def change
    change_column :users, :type, :string
    change_column :users, :style, :string
    change_column :users, :price, :string
    change_column :users, :music, :string
    change_column :users, :mood, :string
    change_column :users, :personality, :string
  end
end
