//
//  RightNowView.swift
//  SWORK
//
//  Created by Aasheesh Kumar Rai on 20/07/21.
//

import UIKit

class RightNowView: FancyView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var primeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    func clear() {
        dateLabel.text = ""
        cityLabel.text = ""
        weatherLabel.text = ""
        weatherImage.image = nil
        primeLabel.text = ""
        dayLabel.text = ""
        minTempLabel.text = ""
        maxTempLabel.text = ""
        tempLabel.text = ""
    }
    
    func updateView(currentWeather: Result, city: String) {
        cityLabel.text = "Current city: \(city)"
        dateLabel.text = Date.getTodaysDate()
        weatherLabel.text = "Description: \(currentWeather.current.weather[0].description.capitalized)"
        weatherImage.image = UIImage(named: currentWeather.current.weather[0].icon)
        dayLabel.text = "Day: \(currentWeather.daily[0].temp.day)"
        minTempLabel.text = "Min temp: \(currentWeather.daily[0].temp.min)"
        maxTempLabel.text = "Max temp: \(currentWeather.daily[0].temp.max)"
        tempLabel.text = "Temp: \(currentWeather.hourly[0].temp)"
        primeLabel.text = Date.isDatePrime(date: Date()) ? "Day number is prime!" : "Day number is not prime!"
    }

}
