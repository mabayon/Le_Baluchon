//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var todayWeatherView: TodayWeatherView!
    @IBOutlet weak var tableView: UITableView!
    
    var networkClient: NetworkClientsService?
    var dataTask: URLSessionDataTask?

    var weatherViewModel: WeatherViewModel?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
      
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func refreshData() {
        guard dataTask == nil else { return }
        
        dataTask = networkClient?.getData(completion: { (weather, error) in
            self.dataTask = nil
            
            guard let weather = weather as? TodayWeather else {
                return
            }
            
            self.weatherViewModel = WeatherViewModel(weather: weather)
            self.weatherViewModel?.configure(imageView: self.todayWeatherView.imageView,
                                             cityLabel: self.todayWeatherView.cityLabel,
                                             tempLabel: self.todayWeatherView.tempLabel,
                                             descriptionLabel: self.todayWeatherView.descriptionLabel,
                                             dayLabel: self.todayWeatherView.dayLabel)
        })
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first,
            location.horizontalAccuracy <= manager.desiredAccuracy {
            OpenWeather.latitude = String(location.coordinate.latitude)
            OpenWeather.longitude = String(location.coordinate.longitude)
            networkClient = NetworkClients.openWeather
//            refreshData()
            locationManager.stopUpdatingLocation()
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier) as! ForecastTableViewCell
        
        return cell
    }
}
