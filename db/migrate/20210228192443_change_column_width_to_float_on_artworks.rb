class ChangeColumnWidthToFloatOnArtworks < ActiveRecord::Migration[6.0]
  def change
    change_column :artworks, :width, :float
  end
end
