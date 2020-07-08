//
//  NetworkClients.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

protocol NetworkClientsService {
    func getData(completion: @escaping (Any?, Error?) -> Void) -> URLSessionDataTask
}
class NetworkClients {
    
    let apiURL: String
    let session: URLSession
    let apiService: APIService
    let responseQueue: DispatchQueue?
    
    static let fixer = NetworkClients(apiURL: Fixer.url,
                                      session: URLSession.shared,
                                      responseQueue: .main,
                                      apiServices: .Fixer)
    
    static let openWeather = NetworkClients(apiURL: OpenWeather.urlCurrentWeather,
                                            session: URLSession.shared,
                                            responseQueue: .main,
                                            apiServices: .OpenWeatherCurrent)
    
    static let openWeatherForecast = NetworkClients(apiURL: OpenWeather.urlForecast,
                                                    session: URLSession.shared,
                                                    responseQueue: .main,
                                                    apiServices: .OpenWeatherForecast)
    
    init(apiURL: String,
         session: URLSession,
         responseQueue: DispatchQueue?,
         apiServices: APIService) {
        
        self.apiURL = apiURL
        self.session = session
        self.responseQueue = responseQueue
        self.apiService = apiServices
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
}

extension NetworkClients: NetworkClientsService {
    
}
