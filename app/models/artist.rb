class Artist < ApplicationRecord
    has_many :artworks
    has_many :departments, through: :artworks
end
