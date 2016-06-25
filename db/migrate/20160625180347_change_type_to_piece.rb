class ChangeTypeToPiece < ActiveRecord::Migration
  def change
    rename_column :users, :type, :piece
  end
end
