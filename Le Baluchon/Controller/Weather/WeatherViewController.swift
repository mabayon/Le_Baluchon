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
    @IBOutlet weak var pageControl: UIPageControl!
    
    var networkCurrentWeather: NetworkClientsService?
    var networkParisWeather: NetworkClientsService?
    var networkNewYorkWeather: NetworkClientsService?

    var networkCurrentForecast: NetworkClientsService?

    var dataTaskCurrentWeather: URLSessionDataTask?
    var dataTaskParisWeather: URLSessionDataTask?
    var dataTaskNewYorkWeather: URLSessionDataTask?
   
    var dataTaskForecast: URLSessionDataTask?

    var currentWeatherViewModel: WeatherViewModel?
    var parisWeatherViewModel: WeatherViewModel?
    var newYorkWeatherViewModel: WeatherViewModel?


    var forecastViewModels: [ForecastViewModel] = []
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupLocationManager()
        
        refreshDataParisWeather()
        refreshDataNewYorkWeather()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupCollectionView() {
        // Register cell classes
        collectionView!.register(WeatherCollectionViewCell.self,
                                 forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = false
        collectionView.backgroundColor = UIColor(red: 250/255, green: 165/255, blue: 98/255, alpha: 1)
    }
    
    // MARK: Current Weather
    func refreshDataCurrentWeather() {
        guard dataTaskCurrentWeather == nil else { return }
        
        networkCurrentWeather = NetworkClients.openWeather
        dataTaskCurrentWeather = networkCurrentWeather?.getData(completion: { (weather, error) in
            self.dataTaskCurrentWeather = nil
            
            guard let weather = weather as? TodayWeather else {
                return
            }
            
            self.currentWeatherViewModel = WeatherViewModel(weather: weather)
            self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        })
    }
    
    func refreshDataCurrentForecast() {
        guard dataTaskForecast == nil else { return }
        
        forecastViewModels = []
        networkCurrentForecast = NetworkClients.openWeatherForecast
        dataTaskForecast = networkCurrentForecast?.getData(completion: { (forecast, error) in
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
            let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? WeatherCollectionViewCell
            cell?.forecastTableView.reloadData()
        })
    }
    
    // MARK: Paris Weather
    func refreshDataParisWeather() {
        guard dataTaskParisWeather == nil else { return }
        
        networkParisWeather = NetworkClients.openWeatherParis
        dataTaskParisWeather = networkParisWeather?.getData(completion: { (weather, error) in
            self.dataTaskParisWeather = nil
            
            guard let weather = weather as? TodayWeather else {
                return
            }
            
            self.parisWeatherViewModel = WeatherViewModel(weather: weather)
            self.collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
        })
    }
    
    // MARK: Paris Weather
    func refreshDataNewYorkWeather() {
        guard dataTaskNewYorkWeather == nil else { return }
        
        networkNewYorkWeather = NetworkClients.openWeatherNewYork
        dataTaskNewYorkWeather = networkNewYorkWeather?.getData(completion: { (weather, error) in
            self.dataTaskNewYorkWeather = nil
            
            guard let weather = weather as? TodayWeather else {
                return
            }
            
            self.newYorkWeatherViewModel = WeatherViewModel(weather: weather)
            self.collectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
        })
    }

    // MARK: PageControl
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first,
            location.horizontalAccuracy <= manager.desiredAccuracy {
            OpenWeather.latitude = String(location.coordinate.latitude)
            OpenWeather.longitude = String(location.coordinate.longitude)
            refreshDataCurrentWeather()
            refreshDataCurrentForecast()
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
        switch indexPath.row {
        case 0:
            currentWeatherViewModel?.configure(cell)
        case 1:
            parisWeatherViewModel?.configure(cell)
        case 2:
            newYorkWeatherViewModel?.configure(cell)
        default:
            break
        }
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let weatherCollectionViewCell = cell as? WeatherCollectionViewCell else { return }
        weatherCollectionViewCell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
        pageControl.currentPage = indexPath.row
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
