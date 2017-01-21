//
//  WhereOnEarth.swift
//  PhotoCollection
//
//  Created by Jason Lew on 10/24/16.
//  Copyright © 2016 Jason Lew. All rights reserved.
//

import Foundation

struct WhereOnEarth {
    let woe_id: String
    let woe_name: String
}

extension WhereOnEarth {
    init(json: Json) throws {
        guard let woeid = json["woeid"] as? String else {
            throw SerializationError.missingKey(Keys.woe_id)
        }
        
        guard let woe_name = json["woe_name"] as? String else {
            throw SerializationError.missingKey("woe_name")
        }
        
        self.woe_id = woeid
        self.woe_name = woe_name
    }
    
    /// Gets the first place returned from a search by place
    ///
    /// - parameter query:      Enter a city, county, etc.
    /// - parameter completion: Returns the most relevant place id and name
    static func topPlace(querying query: String, completion: @escaping (WhereOnEarth) -> Void) {
        let placeRequest = Router.whereIdForQuery(query)
        URLSession.shared.dataTask(with: placeRequest.urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? Json,
            let topResult = json?["places"] as? Json,
            let results = topResult["place"] as? [Json] else {
                return
            }
            // The first result is the most relevant
            if let place = results.first {
                do {
                    let whereOnEarth = try WhereOnEarth(json: place)
                    completion(whereOnEarth)
                } catch let error {
                    print(error)
                }
            }
        }.resume()
    }
}
