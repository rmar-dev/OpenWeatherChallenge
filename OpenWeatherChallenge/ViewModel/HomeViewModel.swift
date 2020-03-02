//
//  HomeViewModel.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 29/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let weather : PublishSubject<WeatherModel> = PublishSubject()
    public let listForecast: PublishSubject<[List]> = PublishSubject()
    public let todayForecast : PublishSubject<[List]> = PublishSubject()
    public let forecast : PublishSubject<[String:[List]]> = PublishSubject()
    public let listOfSchedule: PublishSubject <[String]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<ApiError> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    
    public func requestData(){
        
        let currentWeather = NetworkFunctions.getCurrentWeather(city: .porto)
            .asObservable()
            .materialize()
        
        let forecastWather = NetworkFunctions.getForecast(city: .porto)
            .asObservable()
            .materialize()
        
        listForecast.asObserver()
            .subscribe(onNext: { (list) in
                var futureForecast: Dictionary<String,[List]> = [:]
                var todayForecast: [List] = []
                var dayList: [String] = ["header"]
                
                ///loog the list to filter and seperate by day
                list.forEach { (value) in
                              
                    ///Retrive date from stamp
                    let newDate = Date().getCurrentStamp(stamp: value.dt)
                    
                    ///create a header and days labels to seperate the forecasts by day
                    let dayOfForeccast = Date().checkIfIsSame(input: Date().getFormatedDate(input: newDate))
                              
                    ///Get the firs 10 records to build the graphic
                    if todayForecast.count < 10 {
                        todayForecast.append(value)
                    }
                    
                    ///check if is header, the header tag is created for today list elements, if not add to future forecasts
                    if(dayOfForeccast != "header"){
                     if((futureForecast[dayOfForeccast]) != nil){
                        futureForecast[dayOfForeccast]?.append(value)
                    }else {
                        futureForecast[dayOfForeccast] = []
                        futureForecast[dayOfForeccast]?.append(value)
                        dayList.append(dayOfForeccast)

                    }
                    }}
                
                self.forecast.onNext(futureForecast)
                self.todayForecast.onNext(todayForecast)
                self.listOfSchedule.onNext(dayList)
            })
            .disposed(by: disposeBag)
            
        //Merge the observable to handle toghether
        Observable.zip(currentWeather, forecastWather)
            .subscribe(onNext: { [weak self] weatherJson, forecastJosn  in
                guard let resultWeather = weatherJson.element, let resultForecastList = forecastJosn.element?.list else {
                    self?.error.onNext(.unableToDecode)
                    return
                }
                self?.weather.onNext(resultWeather)
                self?.listForecast.onNext(resultForecastList)
                print("Weather in porto:")
                print("Forecast:")
                self?.loading.onNext(false)
                
            }, onError: { [weak self] error in
                switch error {
                case ApiError.conflict:
                    self?.error.onNext(.conflict)
                case ApiError.forbidden:
                    self?.error.onNext(.forbidden)
                case ApiError.notFound:
                    self?.error.onNext(.notFound)
                default:
                    self?.error.onNext(.unableToDecode)
                }
            })
            .disposed(by: disposeBag)
        
    }
}
