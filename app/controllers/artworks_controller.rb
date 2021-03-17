class ArtworksController < ApplicationController

    def index
        artworks = Artwork.all
        render({json: artworks, except: [:created_at, :updated_at] })
    end
    
end
