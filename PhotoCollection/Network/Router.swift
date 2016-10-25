//
//  Router.swift
//  PhotoCollection
//
//  Created by Jason Lew on 10/24/16.
//  Copyright © 2016 Jason Lew. All rights reserved.
//

import Foundation

enum SerializtionError: Error {
    case missingKey(String)
    case invalidData
}

enum FlickrImageSize: String {
    case smallThumb = "s" // 75x75 square
    case largeThumb = "q" // 150x150 square
    case small      = "n" // 320 on longest side
    case medium     = "z" // 640 on longest side
    case medLarge   = "c" // 800 on longest side
    case large      = "b" // 1024 on longest side
    case xl         = "k" // 2048 on longest side
    case original   = "o"
}

struct Keys {
    static let id = "id"
    static let owner = "owner"
    static let secret = "secret"
    static let server = "server"
    static let farm = "farm"
    static let title = "title"
    static let flickrApiKey = "flickrApiKey"
    static let woe_id = "woe_id"
    static let query = "query"
}

enum HttpMethod: String {
    case POST, GET, PUT, DELETE
}

typealias Json = [String: Any]

enum Router {
    case photosForPlace(String)
    case whereIdForQuery(String)
    
    var baseUrl: String {
        return "https://api.flickr.com"
    }
    
    // Get the API key from the plist.
    var apiKey: String? {
        if let path = Bundle.main.path(forResource: "ApiKey", ofType: "plist") {
            let dict = NSDictionary(contentsOfFile: path)
            return dict?[Keys.flickrApiKey] as? String
        }
        return nil
    }
    
    var urlRequest: URLRequest {
        var queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "per_page", value: "15"),
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        switch self {
            // Gets request for photos from a Where on Earth ID
        case .photosForPlace(let whereId):
            let photosForPlaceQueryItems = [
                URLQueryItem(name: "method", value: "flickr.photos.search"),
                URLQueryItem(name: Keys.woe_id, value: whereId)
            ]
            queryItems += photosForPlaceQueryItems
            // Gets request for Where on Earth ID from place query
        case .whereIdForQuery(let query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            let whereIdQueryItems = [
                URLQueryItem(name: "method", value: "flickr.places.find"),
                URLQueryItem(name: Keys.query, value: encodedQuery)
            ]
            queryItems += whereIdQueryItems
        }
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = "/services/rest/"
        urlComponents?.queryItems = queryItems
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.httpMethod = HttpMethod.GET.rawValue
        
        return urlRequest
    }
    
}
