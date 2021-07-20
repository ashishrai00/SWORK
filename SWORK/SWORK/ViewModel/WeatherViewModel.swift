//
//  WeatherViewModel.swift
//  SWORK
//
//  Created by Aasheesh Kumar Rai on 20/07/21.
//

import Foundation
import UIKit

struct WeatherViewModel {

    let result: Result?
    
    private(set) var dateString = ""
    private(set) var cityString = ""
    private(set) var weatherDesString = ""
    private(set) var weatherImg = ""
    private(set) var primeString = ""
    private(set) var dayString = ""
    private(set) var minTempString = ""
    private(set) var maxTempString = ""
    private(set) var tempString = ""
    
    init(result: Result, cityName: String) {
        self.result = result
        updateProperties()
    }
    
    private mutating func updateProperties() {
        self.dateString = Date.getTodaysDate()
        self.weatherDesString = "Description: \(String(describing: result?.current.weather[0].description.capitalized))"
        self.weatherImg = result?.current.weather[0].icon ?? ""
        self.primeString = Date.isDatePrime(date: Date()) ? "Day number is prime!" : "Day number is not prime!"
        self.dayString = "Day: \(String(describing: result?.daily[0].temp.day))"
        self.minTempString = "Min temp: \(String(describing: result?.daily[0].temp.min))"
        self.maxTempString = "Max temp: \(String(describing: result?.daily[0].temp.max))"
        self.tempString = "Temp: \(String(describing: result?.hourly[0].temp))"
    }
}
