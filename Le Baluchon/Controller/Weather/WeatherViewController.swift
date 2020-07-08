//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 08/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var networkClient: NetworkClientsService?
    var dataTaskCurrentWeather: URLSessionDataTask?
    var dataTaskForecast: URLSessionDataTask?

    var weatherViewModel: WeatherViewModel?
    var forecastViewModels: [ForecastViewModel] = []
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        setupLocationManager()
    }
    
    func setupLocationManager() {
          locationManager.delegate = self
        
          locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
          locationManager.requestWhenInUseAuthorization()
          locationManager.startUpdatingLocation()
    }
        
    func setupCollectionView() {
        // Register cell classes
        self.collectionView!.register(WeatherCollectionViewCell.self,
                                      forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.allowsSelection = false
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
            self.collectionView.reloadData()
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
            self.collectionView.reloadData()
        })
    }

}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first,
            location.horizontalAccuracy <= manager.desiredAccuracy {
            OpenWeather.latitude = String(location.coordinate.latitude)
            OpenWeather.longitude = String(location.coordinate.longitude)
            refreshDataCurrentWeather()
            refreshDataForecast()
            locationManager.stopUpdatingLocation()
        }
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier,
                                                      for: indexPath) as! WeatherCollectionViewCell
    
        // Configure the cell
        weatherViewModel?.configure(cell)
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let weatherCollectionViewCell = cell as? WeatherCollectionViewCell else { return }
        weatherCollectionViewCell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastViewModels.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier) as! ForecastTableViewCell
        guard forecastViewModels.count > 0 else { return cell }
        let viewModel = forecastViewModels[indexPath.row]
        viewModel.configure(cell)
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    
}
