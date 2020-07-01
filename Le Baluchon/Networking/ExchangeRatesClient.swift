//
//  ExchangeRatesClient.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 08/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

protocol ExchangeRatesService {
    func getRates(completion: @escaping (ExchangeRates?, Error?) -> Void) -> URLSessionDataTask
}
class ExchangeRatesClient {
    
    let baseURL: URL
    let session: URLSession
    let responseQueue: DispatchQueue?
    
    static let shared = ExchangeRatesClient(baseURL: URL(string:"http://data.fixer.io/api/")!,
                                            session: URLSession.shared,
                                            responseQueue: .main)
    
    init(baseURL: URL, session: URLSession, responseQueue: DispatchQueue?) {
        self.baseURL = baseURL
        self.session = session
        self.responseQueue = responseQueue
    }
    
    func getRates(completion: @escaping (ExchangeRates?, Error?) -> Void) -> URLSessionDataTask {
        let url = URL(string: "latest?access_key=f5131e4adab602e9918159f221aab859&symbols=USD,GBP,JPY,CNY,CAD", relativeTo: baseURL)!
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
                let rates = try decoder.decode(ExchangeRates.self, from: data)
                self.dispatchResult(models: rates, completion: completion)
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

extension ExchangeRatesClient: ExchangeRatesService {
    
}
