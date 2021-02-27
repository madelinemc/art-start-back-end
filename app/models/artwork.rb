class Artwork < ApplicationRecord
  belongs_to :department
  belongs_to :artist
end
