//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewControllerOld: UIViewController {
    
    @IBOutlet weak var todayWeatherView: TodayWeatherView!
    @IBOutlet weak var tableView: UITableView!
    
    var networkClient: NetworkClientsService?
    var dataTaskCurrentWeather: URLSessionDataTask?
    var dataTaskForecast: URLSessionDataTask?

    var weatherViewModel: WeatherViewModel?
    var forecastViewModels: [ForecastViewModel] = []
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
      
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setupRefreshControl()
        
        tableView.separatorStyle = .none
    }
    
    private func setupRefreshControl() {
      let refreshControl = UIRefreshControl()
      tableView.refreshControl = refreshControl
      
      refreshControl.addTarget(self, action: #selector(refreshDataForecast), for: .valueChanged)
      refreshControl.attributedTitle = NSAttributedString(string: "Chargement...")
    }

    
    func refreshDataCurrentWeather() {
        guard dataTaskCurrentWeather == nil else { return }
        
        networkClient = NetworkClients.openWeather
        dataTaskCurrentWeather = networkClient?.getData(completion: { (weather, error) in
            self.dataTaskCurrentWeather = nil
            
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
    
    @objc func refreshDataForecast() {
        guard dataTaskForecast == nil else { return }
        
        forecastViewModels = []
        networkClient = NetworkClients.openWeatherForecast
        dataTaskForecast = networkClient?.getData(completion: { (forecast, error) in
            self.dataTaskForecast = nil
            
            guard let forecast = forecast as? ForecastWeather else { return }
            
            let forecastManager = ForecastManager(list: forecast.list)
            let lastForecasts = forecastManager.lastForecast
            let tempMaxMin = forecastManager.temps
            for i in 0...lastForecasts.count - 1 {
                let forecast = lastForecasts[i]
                let temps = tempMaxMin[i]
                self.forecastViewModels.append(ForecastViewModel(forecast: forecast, temps: temps))
            }
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
}

extension WeatherViewControllerOld: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first,
            location.horizontalAccuracy <= manager.desiredAccuracy {
            OpenWeather.latitude = String(location.coordinate.latitude)
            OpenWeather.longitude = String(location.coordinate.longitude)
//            refreshDataCurrentWeather()
//            refreshDataForecast()
            locationManager.stopUpdatingLocation()
        }
    }
}

extension WeatherViewControllerOld: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !tableView.refreshControl!.isRefreshing  else {
          return 0
        }
        return max(forecastViewModels.count, 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier) as! ForecastTableViewCell
        guard forecastViewModels.count > 0 else { return cell }
        let viewModel = forecastViewModels[indexPath.row]
        viewModel.configure(cell)
        return cell
    }
}
