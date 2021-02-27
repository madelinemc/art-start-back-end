class CreateArtworks < ActiveRecord::Migration[6.0]
  def change
    create_table :artworks do |t|
      t.references :department, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true
      t.integer :met_identifier
      t.boolean :highlight
      t.string :primary_image_small
      t.string :primary_image
      t.string :name
      t.string :title
      t.string :culture
      t.string :period
      t.string :date
      t.string :medium
      t.integer :height
      t.integer :width
      t.string :url

      t.timestamps
    end
  end
end
