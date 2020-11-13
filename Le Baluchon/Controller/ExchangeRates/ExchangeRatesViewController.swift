//
//  ExchangeRateViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 05/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class ExchangeRatesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var ratesView: UIView! {
        didSet {
            ratesView.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            ratesView.applyShadow()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var converterView: ConverterView!
    
    // MARK: - Instance Properties
    let refreshControl = UIRefreshControl()
    var countryCellImage: UIView?
    
    var networkClient: NetworkClientsService = NetworkClients.fixer
    
    var viewModel: ExchangeRatesViewModel?
    var dataTask: URLSessionDataTask?
    
    var converter: Converter? {
        didSet {
            observeStateChange()
        }
    }
    
    var timer: Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        scrollView.sendSubviewToBack(refreshControl)
      
        refreshData()
    }
    
    // MARK: - IBActions
    @IBAction func swapTapped(_ sender: Any) {
        converter?.state = converter?.state == .fromEUR ? .toEUR : .fromEUR
    }
    
    // MARK: - Observer
    func observeStateChange() {
        converter?.stateChangedCallback = {
            DispatchQueue.main.async {
                self.converterView.swapButtons()
                self.convert(amount: self.converterView.fromCurrencyTF.text)
            }
        }
    }
    
    // MARK: - Convert
    func convert(amount: String?) {
        
        guard let amountText = amount,
              let amount = Double(amountText)
        else { return }
        
        let fromCurrencyName = converterView.fromCurrencyName
        let toCurrencyName = converterView.toCurrencyName
        
        converter?.calculRates(for: amount, fromCurrency: fromCurrencyName, toCurrency: toCurrencyName)
        
        let result = String(converter?.result ?? 0)
        _ = viewModel?.currencies.filter({ $0.name == toCurrencyName }).map {$0.value = result }
        
        viewModel?.configure(fromCurrency: fromCurrencyName,
                             toCurrency: toCurrencyName,
                             completion: { (fromCurrency, toCurrency) in
                                DispatchQueue.main.async {
                                    self.converterView.fromCurrencySymbol = fromCurrency
                                    self.converterView.toCurrencyResult = toCurrency
                                }
                             })
    }
    
    // MARK: - Refresh
    @objc func refreshData() {
        guard dataTask == nil else { return }
        refreshControl.beginRefreshing()
        dataTask = networkClient.getData(completion: { (rates, error) in
            self.dataTask = nil
            self.refreshControl.endRefreshing()

            guard let rates = rates as? ExchangeRates else {
                let alertController = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true)
                }))
                self.present(alertController, animated: true)
                return
            }
            
            self.viewModel = ExchangeRatesViewModel(exchangeRates: rates)
            self.converter = Converter(rates: rates.rates)
            self.converterView.fromCurrencyTF.text = "1"
            self.convert(amount: self.converterView.fromCurrencyTF.text)
            self.collectionView.reloadData()
        })
    }
}

// MARK: - CollectionView DataSource
extension ExchangeRatesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel?.currencies.count else { return 0 }
        
        return count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.identifier, for: indexPath) as! CountryCollectionViewCell
        
        cell.applyShadow()
        cell.delegate = self
        viewModel?.configureCell(cell, for: indexPath.row)
        return cell
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension ExchangeRatesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        swapCurrency(indexPath: indexPath)
    }
    
    func swapCurrency(indexPath: IndexPath) {
        guard let name = viewModel?.currencies[indexPath.row].name else {
            return
        }
        
        switch converter?.state {
        case .fromEUR:
            converterView.toCurrencyName = name
        case .toEUR:
            converterView.fromCurrencyName = name
        case .none:
            break
        }
        convert(amount: converterView.fromCurrencyTF.text)
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension ExchangeRatesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.25
        let height = collectionView.frame.width * 0.25
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let lineSpacing: CGFloat = 20.0
        return lineSpacing
    }
}

extension ExchangeRatesViewController: CountryCollectionViewCellDelegate {
    func getImageContainerWidth(_ width: CGFloat) {
        converterView.updateFromCurrencyWidth(constant: width)
    }
}

// MARK: - TextField Delegate
extension ExchangeRatesViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        converterView.fromCurrencyTF.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.convert(amount: textField.text)
        })
        
        if string.count == 0 && textField.text?.count == 1 {
            if textField.text != "0" {
                textField.text = "0"
            }
            return false
        }
        
        if textField.text == "0" {
            textField.text = ""
        }
        
        return true
    }
}
