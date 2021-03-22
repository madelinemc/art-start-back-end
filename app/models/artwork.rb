class Artwork < ApplicationRecord
  belongs_to :department
  belongs_to :artist

  def self.select_random_artworks
    total_number_artworks = Artwork.all.length

    random_number_array = []
    i = 0
    while i <= 6
      random_id = rand(total_number_artworks)
      if random_number_array.include?(random_id)
      else
        random_number_array << random_id
        i = i + 1
      end
    end
    
    return random_number_array.map { |random_number|
      Artwork.find_by_id(random_number)
    }
  
  end

end
