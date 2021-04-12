class ArtworksController < ApplicationController

    def index
        if params[:department_id]
            artworks = Artwork.select_random_artworks_dept(params[:department_id])
        elsif params[:artist_id] #search term which is the artists name typed by user in front end comes through as artist_id in params
            artworks = Artwork.select_random_artworks_search(params[:artist_id])
        else
            artworks = Artwork.select_random_artworks
        end
        render({json: artworks, except: [:created_at, :updated_at] })
    end

    def show
        art = Artwork.find_by_id(params[:id])
        render({json: art, except: [:created_at, :updated_at] })
    end
    
end
