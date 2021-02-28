# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def get_department_data

    department_data = RestClient.get('https://collectionapi.metmuseum.org/public/collection/v1/departments')
    if department_data.code == 200
        parsed_department_data = JSON.parse(department_data)
        department_array = parsed_department_data['departments']
        department_array.each { |dept|
            department = Department.create(
                name: dept['displayName']
            )
        }
    end

end


def get_artwork_data
    
    artwork_data = RestClient.get('https://collectionapi.metmuseum.org/public/collection/v1/objects')
        if artwork_data.code == 200
            parsed_artwork_data = JSON.parse(artwork_data)
            artwork_array = parsed_artwork_data['objectIDs']

            i = 0
            while i < 10000
                artwork = Artwork.create(met_identifier: artwork_array[i])
                each_artwork_data = RestClient.get('https://collectionapi.metmuseum.org/public/collection/v1/objects/' + artwork.met_identifier.to_s )
                sleep(60/80)
                if each_artwork_data.code == 200
                    parsed_each_artwork_data = JSON.parse(each_artwork_data)
                    if parsed_each_artwork_data['primaryImage'] != nil && parsed_each_artwork_data['primaryImage'] != "" && parsed_each_artwork_data['constituents'] != nil
                        artwork.update(
                            highlight: parsed_each_artwork_data['isHighlight'],
                            primary_image_small: parsed_each_artwork_data['primaryImage'],
                            primary_image: parsed_each_artwork_data['primaryImageSmall'],
                            name: parsed_each_artwork_data['objectName'],
                            title: parsed_each_artwork_data['title'],
                            culture: parsed_each_artwork_data['culture'],
                            period: parsed_each_artwork_data['period'],
                            date: parsed_each_artwork_data['objectDate'],
                            medium: parsed_each_artwork_data['medium'],
                            height: parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Height'],
                            width: parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Width'],
                            depth: parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Depth'],
                            url: parsed_each_artwork_data['objectURL'],
                            
                            department_id: Department.find_by(name: parsed_each_artwork_data['department']).id,
                            artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'][0]['name']).id
                        )
                    end
                end
                i += 1
                if i % 100 == 0
                    puts i
                end
            end     
        end
end

get_department_data
get_artwork_data