//
//  NetworkClients.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkClientsService {
    func getData(completion: @escaping (Any?, Error?) -> Void) -> URLSessionDataTask
    func getRatesWithAlamofire(completion: @escaping (Any?, Error?) -> Void)
}
class NetworkClients {
    
    let apiURL: String
    let session: URLSession
    let apiService: APIService
    let responseQueue: DispatchQueue?
    
    init(apiURL: String,
         session: URLSession,
         responseQueue: DispatchQueue?,
         apiServices: APIService) {
        
        self.apiURL = apiURL
        self.session = session
        self.responseQueue = responseQueue
        self.apiService = apiServices
    }
    
    func getRatesWithAlamofire(completion: @escaping (Any?, Error?) -> Void) {
        let request = Alamofire.request(Fixer.url)
        
        request.responseJSON { (data) in
            guard let data = data.data else { return }
            
            let decoder = JSONDecoder()
            do {
                let rates = try decoder.decode(ExchangeRates.self, from: data)
                self.dispatchResult(models: rates, completion: completion)
            } catch {
                self.dispatchResult(error: error, completion: completion)
            }
        }
    }
    
    func getData(completion: @escaping (Any?, Error?) -> Void) -> URLSessionDataTask {
        let url = URL(string: apiURL)!
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil,
                let data = data else {
                    self.dispatchResult(error: error, completion: completion)
                    return
            }
            let decoder = JSONDecoder()
            do {
                switch self.apiService {
                case .Fixer:
                    let rates = try decoder.decode(ExchangeRates.self, from: data)
                    self.dispatchResult(models: rates, completion: completion)
                case .OpenWeatherCurrent:
                    let currentWeather = try decoder.decode(TodayWeather.self, from: data)
                    self.dispatchResult(models: currentWeather, completion: completion)
                case .OpenWeatherForecast:
                    let forecast = try decoder.decode(ForecastWeather.self, from: data)
                    self.dispatchResult(models: forecast, completion: completion)
                case .GoogleTranslate:
                    let translation = try decoder.decode(Translation.self, from: data)
                    self.dispatchResult(models: translation, completion: completion)
                    
                }
            } catch {
                self.dispatchResult(error: error, completion: completion)
            }
        }
        task.resume()
        return task
    }
    
    private func dispatchResult<Type>(models: Type? = nil,
                                      error: Error? = nil,
                                      completion: @escaping (Type?, Error?) -> Void) {
        guard let responseQueue = self.responseQueue else {
            completion(models, error)
            return
        }
        responseQueue.async {
            completion(models, error)
        }
    }
    
    func reloadGoogleTranslate() {
        NetworkClients.googleTranslate = NetworkClients(apiURL: GoogleTranslate.url,
                                         session: URLSession.shared,
                                         responseQueue: .main,
                                         apiServices: .GoogleTranslate)
    }
}

extension NetworkClients {
    
    // MARK: Shared Instance
    
    static let fixer = NetworkClients(apiURL: Fixer.url,
                                      session: URLSession.shared,
                                      responseQueue: .main,
                                      apiServices: .Fixer)
    
    static let openWeather = NetworkClients(apiURL: OpenWeather.urlCurrentWeather,
                                            session: URLSession.shared,
                                            responseQueue: .main,
                                            apiServices: .OpenWeatherCurrent)
    
    static let openWeatherParis = NetworkClients(apiURL: OpenWeather.urlParisWeather,
                                                 session: URLSession.shared,
                                                 responseQueue: .main,
                                                 apiServices: .OpenWeatherCurrent)
    
    static let openWeatherNewYork = NetworkClients(apiURL: OpenWeather.urlNewYorkWeather,
                                                   session: URLSession.shared,
                                                   responseQueue: .main,
                                                   apiServices: .OpenWeatherCurrent)
    
    static let openWeatherForecast = NetworkClients(apiURL: OpenWeather.urlForecastCurrent,
                                                    session: URLSession.shared,
                                                    responseQueue: .main,
                                                    apiServices: .OpenWeatherForecast)
    
    static let openWeatherForecastParis = NetworkClients(apiURL: OpenWeather.urlForecastParis,
                                                         session: URLSession.shared,
                                                         responseQueue: .main,
                                                         apiServices: .OpenWeatherForecast)
    
    static let openWeatherForecastNewYork = NetworkClients(apiURL: OpenWeather.urlForecastNewYork,
                                                           session: URLSession.shared,
                                                           responseQueue: .main,
                                                           apiServices: .OpenWeatherForecast)
    
    static var googleTranslate = NetworkClients(apiURL: GoogleTranslate.url,
                                                session: URLSession.shared,
                                                responseQueue: .main,
                                                apiServices: .GoogleTranslate)
}

// For testing purpose
extension NetworkClients: NetworkClientsService {
}
