class ChangeColumnHeightToFloatOnArtworks < ActiveRecord::Migration[6.0]
  def change
    change_column :artworks, :height, :float
  end
end
