//
//  NetworkContants.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 25/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation

struct NetworkContants {
    
    //The API's base URL
    static let baseUrl = "https://api.openweathermap.org/data/2.5"
    static let imageUrl = "https://openweathermap.org/img/w/"
    static let apiKey = "c0850aabb6da90612ed04f8d37e3d862"
    static let metric = "metric"
    //list of cities
    enum Cities: String {
        case porto = "Porto,pt"
    }
    
    //The parameters (Queries) that we're gonna use
    enum Parameters: String {
        case q = "q"
        case appId = "APPID"
        case units = "units"
    }
    
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
}
