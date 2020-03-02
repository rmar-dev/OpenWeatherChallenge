//
//  Extensions.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 29/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation

extension Date {
    func getCurrentStamp(stamp: Int?) -> Date {
        guard let stamp = stamp else {
            return NSDate.now as Date
        }
        let myTimeInterval = TimeInterval(stamp)
        return Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
    }
    
    func checkIfIsSame(input: String) -> String {
        let today = Date()
        if(input == getFormatedDate(input: today)){
            return "header"
        }else if let tomorow = Calendar.current.date(byAdding: .day, value: 1, to: today), (input == getFormatedDate(input: tomorow) ){
            return "Tomorrow\(input.removeAfter(char: ","))"
        }else {
            return input
        }
    }
    
    func nextDay() {
        var dayComponent    = DateComponents()
        dayComponent.day    = 1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
    }
    
    func getFormatedDate(input: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let formater = DateFormatter()
        formater.dateFormat = "EEEE, MMMM dd"
        if let date = dateFormatterGet.date(from: "\(input)") {
            return(formater.string(from: date))
        } else {
            return("There was an error decoding the string")
        }
    }
    
    func getFormatHours(input: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let formater = DateFormatter()
        formater.dateFormat = "HH"
        if let date = dateFormatterGet.date(from: "\(input)") {
            return(formater.string(from: date))
        } else {
            return("There was an error decoding the string")
        }
    }
}
