//
//  Photo.swift
//  PhotoCollection
//
//  Created by Jason Lew on 10/24/16.
//  Copyright © 2016 Jason Lew. All rights reserved.
//

import Foundation

struct Photo {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let imageUrl: URL
    var placeTitle: String?
}

extension Photo {
    init(json: Json) throws {
        guard let id = json[Keys.id] as? String else {
            throw SerializationError.missingKey(Keys.id)
        }
        
        guard let owner = json[Keys.owner] as? String else {
            throw SerializationError.missingKey(Keys.owner)
        }
        
        guard let secret = json[Keys.secret] as? String else {
            throw SerializationError.missingKey(Keys.secret)
        }
        
        guard let server = json[Keys.server] as? String else {
            throw SerializationError.missingKey(Keys.server)
        }
        
        guard let farm = json[Keys.farm] as? Int else {
            throw SerializationError.missingKey(Keys.farm)
        }
        
        guard let title = json[Keys.title] as? String else {
            throw SerializationError.missingKey(Keys.title)
        }
        
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        
        let path = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(FlickrImageSize.medLarge.rawValue).jpg"
        self.imageUrl = URL(string: path)!
    }
    
    static func photos(querying query: WhereOnEarth, completion: @escaping ([Photo]) -> Void) {
        let photosRequest = Router.photosForPlace(query.woe_id).urlRequest
        URLSession.shared.dataTask(with: photosRequest) { (data, response, error) in
            if let _ = error {
                return
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? Json else {
                return
            }
            guard let topResults = json?["photos"] as? Json,
            let results = topResults["photo"] as? [Json] else {
                return
            }
            var photos = [Photo]()
            for result in results {
                do {
                    var photo = try Photo(json: result)
                    photo.placeTitle = query.woe_name
                    photos.append(photo)
                } catch let error {
                    print(error)
                }
            }
            completion(photos)
        }.resume()
    }
}











