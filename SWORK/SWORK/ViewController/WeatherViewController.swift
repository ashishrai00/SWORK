//
//  WeatherViewController.swift
//  SWORK
//
//  Created by Aasheesh Kumar Rai on 20/07/21.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var rightNowView: RightNowView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var viewModel: WeatherViewModel?
    var activityView: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUIElements()
        initViewModal()
        clearAll()
        viewModel?.showLoading?()
        viewModel?.getLocation()
    }

    func initViewModal() {
        self.viewModel = WeatherViewModel.init()
        self.viewModel?.hideLoading = {
            DispatchQueue.main.async {
                self.activityView?.stopAnimating()
            }
        }
        self.viewModel?.showLoading = { [weak self] in
            if self?.activityView == nil {
                self?.activityView = UIActivityIndicatorView(style: .large)
            }
            self?.activityView?.center = self?.view.center ?? CGPoint(x: 0, y: 0)
            self?.activityView?.startAnimating()
            self?.view.addSubview(self?.activityView ?? UIActivityIndicatorView())
        }
        self.viewModel?.updateViews = {
            self.updateTopView()
        }
    }

    func initUIElements() {
        self.activityView = UIActivityIndicatorView(style: .large)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    func clearAll() {
        rightNowView.clear()
    }
    
    func updateViews() {
        updateTopView()
    }
    
    func updateTopView() {
        guard let weatherResult = viewModel?.result, let city = viewModel?.city, let selectedDate = viewModel?.selectedDate else {
            return
        }
        rightNowView.updateView(currentWeather: weatherResult, city: city, date: selectedDate)
    }
    
    @IBAction func getWeatherTapped(_ sender: UIButton) {
        clearAll()
        viewModel?.showLoading?()
        viewModel?.getLocation()
    }
}

// Date Picker Implementation
extension WeatherViewController {
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        self.dismiss(animated: true, completion: nil)
        self.viewModel?.selectedDate = sender.date
        if Date.isDatePrime(date: sender.date) {
            self.rightNowView.primeLabel.text = ""
            APIManager.shared.DATE = "\(sender.date.timeIntervalSince1970)"
            self.viewModel?.getWeather()
        } else {
            self.rightNowView.primeLabel.text = "Day number is not prime!"
        }
    }
}
