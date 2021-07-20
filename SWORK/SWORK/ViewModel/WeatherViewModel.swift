//
//  WeatherViewModel.swift
//  SWORK
//
//  Created by Aasheesh Kumar Rai on 20/07/21.
//

import Foundation
import UIKit
import MapKit

class WeatherViewModel: NSObject {

    var result: Result?
    
    private(set) var dateString = ""
    private(set) var cityString = ""
    private(set) var weatherDesString = ""
    private(set) var weatherImg = ""
    private(set) var primeString = ""
    private(set) var dayString = ""
    private(set) var minTempString = ""
    private(set) var maxTempString = ""
    private(set) var tempString = ""

    var selectedDate = Date()
    var locationManger: CLLocationManager!
    var currentlocation: CLLocation?
    var city = ""

    var showLoading: (()->())?
    var hideLoading: (()->())?
    var updateViews: (()->())?
    var apiManager = APIManager()

    override init() {
        super.init()
        self.updateProperties()
    }
    
    func getWeather() {
        showLoading?()
        apiManager.getWeather(onSuccess: { [weak self] (result) in
            self?.hideLoading?()
            self?.result = result
            
            self?.result?.sortDailyArray()
            self?.result?.sortHourlyArray()
            self?.updateViews?()
            
        }) { (errorMessage) in
            self.hideLoading?()
            debugPrint(errorMessage)
        }
    }

    func getLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManger = CLLocationManager()
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.requestWhenInUseAuthorization()
            locationManger.requestLocation()
        }
    }

    private func updateProperties() {
        self.dateString = Date.getDateString()
        self.weatherDesString = "Description: \(String(describing: result?.current.weather[0].description.capitalized))"
        self.weatherImg = result?.current.weather[0].icon ?? ""
        self.primeString = Date.isDatePrime(date: Date()) ? "Day number is prime!" : "Day number is not prime!"
        self.dayString = "Day: \(String(describing: result?.daily[0].temp.day))"
        self.minTempString = "Min temp: \(String(describing: result?.daily[0].temp.min))"
        self.maxTempString = "Max temp: \(String(describing: result?.daily[0].temp.max))"
        self.tempString = "Temp: \(String(describing: result?.hourly[0].temp))"
    }
}

// Location delegate
extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentlocation = location
            
            let latitude: Double = self.currentlocation!.coordinate.latitude
            let longitude: Double = self.currentlocation!.coordinate.longitude
            
            APIManager.shared.setLatitude(latitude)
            APIManager.shared.setLongitude(longitude)
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.locality {
                            self.city = city
                        }
                    }
                }
            }
            self.getWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}
