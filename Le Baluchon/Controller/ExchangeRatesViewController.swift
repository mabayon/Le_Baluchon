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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var converterView: ConverterView!
    
    // MARK: - Instance Properties
    var countryCellImage: UIView?
    
    var networkClient: ExchangeRatesService = ExchangeRatesClient.shared
    
    var viewModel: ExchangeRatesViewModel?
    var dataTask: URLSessionDataTask?
    
    var converter: Converter?
    var timer: Timer?
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        converter?.stateChangedCallback = { model in
            DispatchQueue.main.async {
                self.converterView.swapButtons()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      refreshData()
    }
        
    // MARK: - IBActions
    @IBAction func swapTapped(_ sender: Any) {
        converterView.swapButtons()
        converter?.state = converter?.state == .fromEUR ? .toEUR : .fromEUR
        convert(amount: converterView.fromDeviseTF.text)
    }
    
    // MARK: - Convert
    func convert(amount: String?) {
        
        guard let amountText = amount,
            let amount = Double(amountText),
            let fromDeviseName = converterView.fromDeviseName,
            let toDeviseName = converterView.toDeviseName
            else { return }
        
        
        converter?.calculRates(for: amount, fromDevise: fromDeviseName, toDevise: toDeviseName)
    
        let result = String(converter?.result ?? 0)
        let toDeviseSymbol = viewModel?.getSymbol(for: toDeviseName) ?? ""
        converterView.fromDeviseSymbol = viewModel?.getSymbol(for: fromDeviseName)
        converterView.toDeviseResult = result + toDeviseSymbol
    }
        
    // MARK: - Refresh
    @objc func refreshData() {
        guard dataTask == nil else { return }
        
        dataTask = networkClient.getRates(completion: { (rates, error) in
            self.dataTask = nil
            
            guard let rates = rates else {
                return
            }
            
            self.viewModel = ExchangeRatesViewModel(exchangeRates: rates)
            self.converter = Converter(rates: rates.rates)
            self.converterView.fromDeviseTF.text = "1"
            self.convert(amount: self.converterView.fromDeviseTF.text)
            self.collectionView.reloadData()
        })
    }
}

// MARK: - CollectionView DataSource
extension ExchangeRatesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel?.devises.count else { return 0 }
        
        return count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.identifier, for: indexPath) as! CountryCollectionViewCell

        cell.applyShadow()
        cell.delegate = self
        
        guard let arrayWithoutEUR = viewModel?.devises.filter({ $0.name != "EUR" })
            else { return cell }
     
        cell.name = arrayWithoutEUR[indexPath.row].name
        return cell
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension ExchangeRatesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        swapCurrencies(indexPath: indexPath)
    }
    
    func swapCurrencies(indexPath: IndexPath) {
        guard let name = viewModel?.devises[indexPath.row].name else {
            return
        }
        
        switch converter?.state {
        case .fromEUR:
            converterView.toDeviseName = name
        case .toEUR:
            converterView.fromDeviseName = name
        case .none:
            break
        }
        convert(amount: converterView.fromDeviseTF.text)
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
        converterView.updateFromDeviseWidth(constant: width)
    }
}

// MARK: - TextField Delegate
extension ExchangeRatesViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        converterView.fromDeviseTF.resignFirstResponder()
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
