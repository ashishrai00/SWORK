//
//  SWORKTests.swift
//  SWORKTests
//
//  Created by Aasheesh Kumar Rai on 19/07/21.
//

import XCTest
import MapKit
@testable import SWORK

class SWORKTests: XCTestCase {

    let viewModel = MockWeatherViewModel.init()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let mockApiManager = MockAPIManager()
        viewModel.apiManager = mockApiManager
        viewModel.getLocation()
        XCTAssertNotEqual(self.viewModel.city, "")
        self.viewModel.getWeather()
        XCTAssertTrue(mockApiManager.isGetWeatherAPICalled)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class MockAPIManager: APIManager {
    var isGetWeatherAPICalled = false
    override func getWeather(onSuccess: @escaping (Result) -> Void, onError: @escaping (String) -> Void) {
        super.getWeather(onSuccess: onSuccess, onError: onError)
        isGetWeatherAPICalled = true
    }
}

class MockWeatherViewModel: WeatherViewModel {
    override func getLocation() {
        super.getLocation()
        self.city = "Noida"
    }
    override func getWeather() {
        super.getWeather()
    }
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
    }
}
