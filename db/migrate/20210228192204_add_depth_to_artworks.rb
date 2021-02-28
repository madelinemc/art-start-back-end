class AddDepthToArtworks < ActiveRecord::Migration[6.0]
  def change
    add_column :artworks, :depth, :float
  end
end
