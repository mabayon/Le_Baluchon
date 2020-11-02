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
    
    var networkClient: NetworkClientsService?
    
    var dataTaskCurrentWeather: URLSessionDataTask?
    var dataTaskParisWeather: URLSessionDataTask?
    var dataTaskNewYorkWeather: URLSessionDataTask?
    
    var dataTaskForecastCurrent: URLSessionDataTask?
    var dataTaskForecastParis: URLSessionDataTask?
    var dataTaskForecastNewYork: URLSessionDataTask?
    
    var currentWeatherViewModel: WeatherViewModel?
    var parisWeatherViewModel: WeatherViewModel?
    var newYorkWeatherViewModel: WeatherViewModel?
    
    var forecastViewModels: [ForecastViewModel] = []
    var forecastParisViewModels: [ForecastViewModel] = []
    var forecastNewYorkViewModels: [ForecastViewModel] = []
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupLocationManager()
        
        dataTaskParisWeather = refreshDataCurrentWeather(dataTask: dataTaskParisWeather,
                                                         networkClient: .openWeatherParis,
                                                         for: .paris)
        
        dataTaskForecastParis = refreshDataForecast(dataTask: dataTaskForecastParis,
                                                    networkClient: .openWeatherForecastParis,
                                                    for: .paris)
        
        dataTaskNewYorkWeather = refreshDataCurrentWeather(dataTask: dataTaskNewYorkWeather,
                                                           networkClient: .openWeatherNewYork,
                                                           for: .newYork)
        
        dataTaskForecastNewYork = refreshDataForecast(dataTask: dataTaskForecastNewYork,
                                                      networkClient: .openWeatherForecastNewYork,
                                                      for: .newYork)
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
    
    enum Location {
        case current, paris, newYork
    }
    
    func refreshDataCurrentWeather(dataTask: URLSessionDataTask?,
                                   networkClient: NetworkClients?,
                                   for location: Location) -> URLSessionDataTask? {
        
        guard dataTask == nil else { return dataTask }
        
        return networkClient?.getData(completion: { (weather, error) in
            
            guard let weather = weather as? TodayWeather else {
                let alertController = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true)
                }))
                self.present(alertController, animated: true)
                return
            }
            
            switch location {
            case .current:
                self.dataTaskCurrentWeather = nil
                self.currentWeatherViewModel = WeatherViewModel(weather: weather)
            case .paris:
                self.dataTaskParisWeather = nil
                self.parisWeatherViewModel = WeatherViewModel(weather: weather)
            case .newYork:
                self.dataTaskNewYorkWeather = nil
                self.newYorkWeatherViewModel = WeatherViewModel(weather: weather)
            }
            
            self.collectionView.reloadData()
        })
    }
    
    func refreshDataForecast(dataTask: URLSessionDataTask?,
                             networkClient: NetworkClients?,
                             for location: Location) -> URLSessionDataTask? {
        
        guard dataTask == nil else { return dataTask }
        
        forecastViewModels = []
        return networkClient?.getData(completion: { (forecast, error) in
            
            guard let forecast = forecast as? ForecastWeather else {
                let alertController = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true)
                }))
                self.present(alertController, animated: true)
                return
            }
            
            var cell: WeatherCollectionViewCell?
            switch location {
            case .current:
                self.dataTaskForecastCurrent = nil
                self.forecastViewModels = self.createForecastViewModels(forecast: forecast)
                cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? WeatherCollectionViewCell
            case .paris:
                self.dataTaskForecastParis = nil
                self.forecastParisViewModels = self.createForecastViewModels(forecast: forecast)
                cell = self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? WeatherCollectionViewCell
            case .newYork:
                self.dataTaskForecastNewYork = nil
                self.forecastNewYorkViewModels = self.createForecastViewModels(forecast: forecast)
                cell = self.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? WeatherCollectionViewCell
            }
            cell?.forecastTableView.reloadData()
        })
    }
    
    func createForecastViewModels(forecast: ForecastWeather) -> [ForecastViewModel] {
        var forecastViewModels: [ForecastViewModel] = []
        let forecastManager = ForecastManager(list: forecast.list)
        let lastForecasts = forecastManager.lastForecast
        let tempMaxMin = forecastManager.temps
        for i in 0...lastForecasts.count - 1 {
            let forecast = lastForecasts[i]
            let temps = tempMaxMin[i]
            forecastViewModels.append(ForecastViewModel(forecast: forecast, temps: temps))
        }
        return forecastViewModels
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
            dataTaskCurrentWeather = refreshDataCurrentWeather(dataTask: dataTaskCurrentWeather,
                                                               networkClient: .openWeather,
                                                               for: .current)
            dataTaskForecastCurrent = refreshDataForecast(dataTask: dataTaskForecastCurrent,
                                                          networkClient: .openWeatherForecast,
                                                          for: .current)
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
        
        switch tableView.superview?.superview {
        case collectionView.cellForItem(at: IndexPath(row: 0, section: 0)):
            let viewModel = forecastViewModels[indexPath.row]
            viewModel.configure(cell)
        case collectionView.cellForItem(at: IndexPath(row: 1, section: 0)):
            let viewModel = forecastParisViewModels[indexPath.row]
            viewModel.configure(cell)
        case collectionView.cellForItem(at: IndexPath(row: 2, section: 0)):
            let viewModel = forecastNewYorkViewModels[indexPath.row]
            viewModel.configure(cell)
            
        default:
            break
        }
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    
}
