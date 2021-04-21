# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).



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


def get_artwork_data #ENTIRE API
    
    artwork_data = RestClient.get('https://collectionapi.metmuseum.org/public/collection/v1/objects')
        if artwork_data.code == 200
            parsed_artwork_data = JSON.parse(artwork_data)
            artwork_array = parsed_artwork_data['objectIDs']

            i = 5244
            while i < 10000
                each_artwork_data = RestClient.get('https://collectionapi.metmuseum.org/public/collection/v1/objects/' + artwork_array[i].to_s )
                sleep(3)
                if each_artwork_data.code == 200
                    parsed_each_artwork_data = JSON.parse(each_artwork_data)
                    if parsed_each_artwork_data['primaryImage'] != nil && parsed_each_artwork_data['primaryImage'] != "" && parsed_each_artwork_data['constituents'] != nil
                        artwork = Artwork.find_or_create_by(met_identifier: artwork_array[i])
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
                            height: parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Height'] ? parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Height'] : "",
                            width: parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Width'] ? parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Width'] : "",
                            depth: parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Depth'] ? parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Depth'] : "",
                            url: parsed_each_artwork_data['objectURL'],
                            
                            department_id: Department.find_or_create_by(name: parsed_each_artwork_data['department']).id,
                            artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'][0]['name']).id
                        )
                    else
                    end
                end
                puts i
                i += 1
                # if i % 100 == 0
                #     puts i
                # end
            end     
        end
end

def get_artwork_by_dept_data(met_dept_id) #BY DEPARTMENT

    artwork_data = RestClient.get('https://collectionapi.metmuseum.org/public/collection/v1/objects?departmentIds=' + met_dept_id.to_s )
    if artwork_data.code == 200
        parsed_artwork_data = JSON.parse(artwork_data)
        artwork_array = parsed_artwork_data['objectIDs']

        i = 400
        while i < 3000
            each_artwork_data = RestClient.get('https://collectionapi.metmuseum.org/public/collection/v1/objects/' + artwork_array[i].to_s )
            sleep(1)
                if each_artwork_data.code == 200
                    parsed_each_artwork_data = JSON.parse(each_artwork_data)
                    if parsed_each_artwork_data['primaryImage'] != nil && parsed_each_artwork_data['primaryImage'] != "" #&& parsed_each_artwork_data['constituents'] != nil
                        artwork = Artwork.find_or_create_by(met_identifier: artwork_array[i])
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
                            height: parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Height'] ? parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Height'] : "",
                            width: parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Width'] ? parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Width'] : "",
                            depth: parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Depth'] ? parsed_each_artwork_data['measurements'][0]['elementMeasurements']['Depth'] : "",
                            url: parsed_each_artwork_data['objectURL'],
                            
                            department_id: Department.find_or_create_by(name: parsed_each_artwork_data['department']).id,
                            artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Artist Arms and Armor").id
                        )
                    else
                    end
                end
                puts i
                i += 1
            end     
        end
    end

#get_department_data
#get_artwork_data
get_artwork_by_dept_data(4)

#PROGRESS THROUGH EACH DEPARTMENT:
#"The American Wing" 96  ----GOT UP TO artwork_array[5244] roughly 1000 db entries
#"Egyptian Art" 9,  (met id is 10) ----GOT UP TO artwork_array[12000] roughly 100 db entries   artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'][0]['name'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Ancient Egyptians").id
#"European Paintings" 10 (met id is 11) ----GOT ALL artwork_array[2611] roughly 1900 db entries  Artwork.all.length is 2967
#"Greek and Roman Art" 12, (met id is 13) ----GOT UP TO artwork_array[2181] roughly 1300 db entries  Artwork.all.length is 4282    artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Ancient Greek and Roman Artists").id + line 80 = #&& parsed_each_artwork_data['constituents'] != nil
#"Modern Art" 19, (met id is 21) ----GOT UP TO arwork_array[14046] roughly 180 db entries Artwork.all.length is 4461
#"Medieval Art" 16, (met id is 17) ----GOT UP TO arwork_array[2104] roughly 1730 db entries Artwork.all.length is 6191    artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Medieval Artist").id + line 80 = #&& parsed_each_artwork_data['constituents'] != nil
#"The Costume Institute" 7, (met id is 8) ----GOT UP TO arwork_array[2291] roughly 27 db entries Artwork.all.length is 6218    artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Costume Designer").id
#"Arts of Africa, Oceania, and the Americas" 4, (met id is 5) ----GOT UP TO arwork_array[50] roughly 22 db entries Artwork.all.length is 6240    artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Arist Africa, Oceania, and the Americas").id
#"Ancient Near Eastern Art" 2, (met id is 3) ----GOT UP TO arwork_array[317] roughly 315 db entries Artwork.all.length is 6555     artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Ancient Near Eastern Artist").id
#"Asian Art" 5, (met id is 6) ----GOT UP TO arwork_array[210] roughly 210 db entries Artwork.all.length is 6765     artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Asian Artist").id
#"The Cloisters" 6, (met id is 7) ----GOT UP TO arwork_array[204] roughly 385 db entries Artwork.all.length is 7150     artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Artist Cloisters").id
#"European Sculpture and Decorative Arts" 11, (met id is 12) ----GOT UP TO arwork_array[299] roughly 266 db entries Artwork.all.length is 7416      artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown European Artist").id
#"Islamic Art" 13, (met id is 14) ----GOT UP TO arwork_array[233] roughly 35 db entries Artwork.all.length is 7451      artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Islamic Artist").id
#"Drawings and Prints" 8, (met id is 9) ----GOT UP TO arwork_array[398] roughly 225 db entries Artwork.all.length is 7676     artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Artist Drawings and Prints").id
# "The Libraries" 15, (met id is 16) ----GOT UP TO arwork_array[197] roughly 41 db entries Artwork.all.length is 7717     artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Artist Libraries").id
# "American Decorative Arts" 1, (met id is 1) ----GOT UP TO arwork_array[396] roughly 134 db entries Artwork.all.length is 7851     artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown American Artist").id
# "The Robert Lehman Collection" 14, (met id is 15) ----GOT UP TO arwork_array[193] roughly 173 db entries Artwork.all.length is 8024     artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Artist from Robert Lehman Collection").id
#"Arms and Armor" 3, (met id is 4) ----GOT UP TO arwork_array[400] roughly 9 db entries Artwork.all.length is 8033     artist_id: Artist.find_or_create_by(name: parsed_each_artwork_data['constituents'] != nil ? parsed_each_artwork_data['constituents'][0]['name'] : "Unknown Artist Arms and Armor").id


#UNUSED DEPTS:
# "Musical Instruments" 17, (met id is 18) ----IN PROGRESS
#"Photographs" 18, (met id is 19)
