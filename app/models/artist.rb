class Artist < ApplicationRecord
    has_many :artworks
    has_many :departments, through: :artworks

    scope :artists_by_search, -> (artist) { where('name LIKE ?', "%#{artist}%") } #array of artists
    
end
