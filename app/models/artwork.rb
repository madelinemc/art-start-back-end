class Artwork < ApplicationRecord
  belongs_to :department
  belongs_to :artist

  #RANDOM:
  def self.select_random_artworks
    total_number_artworks = Artwork.all.length

    random_number_array = []
    i = 0
    while i <= 4
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

  #DEPT:
  scope :art_by_dept, -> (dept) { where('department_id = ?', dept.to_i) }

  def self.select_random_artworks_dept(dept)
    all_art_by_dept = Artwork.art_by_dept(dept)
    total_number_artworks = all_art_by_dept.length

    random_number_array = []
    i = 0
    while i <= 4
      random_id = rand(total_number_artworks)
      if random_number_array.include?(random_id)
      else
        random_number_array << random_id
        i = i + 1
      end
    end
    
    return random_number_array.map { |random_number|
      all_art_by_dept[random_number]
    }

  end

  #SEARCH: 
  scope :art_by_search, -> (id) { where('artist_id = ?', id.to_i)}

  def self.select_random_artworks_search(search)
    searched_artists_array = Artist.artists_by_search(search)
    array_of_artist_ids = searched_artists_array.map { |artist| artist.id }
    
    all_art_by_search = []
    array_of_artist_ids.each { |artist_id| 
      Artwork.art_by_search(artist_id).each { |single_art_piece| all_art_by_search << single_art_piece }
    }
    
    total_number_artworks = all_art_by_search.length

    random_number_array = []
    i = 0
    if total_number_artworks > 4
      while i <= 4
        random_id = rand(total_number_artworks)
        if random_number_array.include?(random_id)
        else
          random_number_array << random_id
          i = i + 1
        end
      end
    else
      random_number_array = (0..(total_number_artworks - 1)).to_a
    end
    
    return random_number_array.map { |random_number|
      all_art_by_search[random_number]
    }

  end



end
