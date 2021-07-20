//
//  WeatherViewController.swift
//  SWORK
//
//  Created by Aasheesh Kumar Rai on 20/07/21.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var rightNowView: RightNowView!
    
    var city = ""
    var locationManger: CLLocationManager!
    var currentlocation: CLLocation?
    var viewModel: WeatherViewModel?
    var activityView: UIActivityIndicatorView?
    
    var searchResult: Result? {
        didSet {
            guard let searchResult = searchResult else { return }
            self.viewModel = WeatherViewModel.init(result: searchResult, cityName: self.city)
            DispatchQueue.main.async {
                self.activityView?.stopAnimating()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
        self.showActivity()
        getLocation()
    }
    
    func clearAll() {
        rightNowView.clear()
    }
    
    func getWeather() {
        APIManager.shared.getWeather(onSuccess: { (result) in
            self.searchResult = result
            
            self.searchResult?.sortDailyArray()
            self.searchResult?.sortHourlyArray()
            self.updateViews()
            
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    func updateViews() {
        updateTopView()
    }
    
    func updateTopView() {
        guard let weatherResult = viewModel?.result else {
            return
        }
        
        rightNowView.updateView(currentWeather: weatherResult, city: city)
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
            
            getWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    @IBAction func getWeatherTapped(_ sender: UIButton) {
        clearAll()
        showActivity()
        getLocation()
    }
    
    @IBAction func todayWeeklyValueChanged(_ sender: UISegmentedControl) {
        clearAll()
        updateViews()
    }
    
    private func showActivity() {
        self.activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        activityView?.startAnimating()

        self.view.addSubview(activityView ?? UIActivityIndicatorView())
    }
}
