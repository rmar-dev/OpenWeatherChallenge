//
//  NetworkFunctions.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 25/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Kingfisher


// Error handler
enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
    case unableToDecode
}

class NetworkFunctions {
    
    static func getCurrentWeather(city: NetworkContants.Cities) -> Observable<WeatherModel> {
        return request(Router.getCurrentWeather(city: city))
    }
    
    static func getForecast(city: NetworkContants.Cities) -> Observable<ForecastModel> {
        return request(Router.getForecast(city: city))
    }
    
    static func getIconUrl(icon: String) -> URL? {
        if let url = URL(string: "\(NetworkContants.imageUrl)\(icon).png"){
            return url
        }
        return nil
    }

    //-------------------------------------------------------------------------------------------------
    //MARK: - The request function to get results in an Observable
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
