//
//  ExchangeRateViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 05/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class ExchangeRatesViewController: UIViewController {
    
    // MARK: - Instance Properties
    var networkClient: ExchangeRatesService = ExchangeRatesClient.shared
    
    var viewModels: ExchangeRatesViewModel?
    var dataTask: URLSessionDataTask?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Refresh
    @objc func refreshData() {
        guard dataTask == nil else { return }
        
        dataTask = networkClient.getRates(completion: { (rates, error) in
            self.dataTask = nil
            
            self.viewModels = ExchangeRatesViewModel(exchangeRates: rates!)
        })
    }
}
