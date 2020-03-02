//
//  router.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 25/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    //The endpoint name we'll call later
    case getCurrentWeather(city: NetworkContants.Cities)
    case getForecast(city: NetworkContants.Cities)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkContants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(NetworkContants.ContentType.json.rawValue, forHTTPHeaderField: NetworkContants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(NetworkContants.ContentType.json.rawValue, forHTTPHeaderField: NetworkContants.HttpHeaderField.contentType.rawValue)
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: HTTPMethod {
        switch self {
        case .getCurrentWeather:
            return .get
        case .getForecast:
            return .get
        }
    }
    
    //MARK: - Path
    //The path is the part following the base url
    private var path: String {
        switch self {
        case .getCurrentWeather:
            return "/weather"
        case .getForecast:
            return "/forecast"
        }
    }
    
    //MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: Parameters? {
        switch self {
        case .getCurrentWeather(let city):
            return [
                NetworkContants.Parameters.q.rawValue : city,
                NetworkContants.Parameters.appId.rawValue : NetworkContants.apiKey,
                NetworkContants.Parameters.units.rawValue : NetworkContants.metric

            ]
            
        case .getForecast(let city):
            return [
                NetworkContants.Parameters.q.rawValue : city,
                NetworkContants.Parameters.appId.rawValue : NetworkContants.apiKey,
                NetworkContants.Parameters.units.rawValue : NetworkContants.metric
            ]
        }
    }
    
}
