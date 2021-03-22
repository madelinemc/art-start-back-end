class ArtworksController < ApplicationController

    def index
        artworks = Artwork.select_random_artworks
        render({json: artworks, except: [:created_at, :updated_at] })
    end

    def show
        art = Artwork.find_by_id(params[:id])
        render({json: art, except: [:created_at, :updated_at] })
    end
    
end
