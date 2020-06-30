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
    }

    override func viewDidAppear(_ animated: Bool) {
        if let countryCellImage = countryCellImage {
            converterView.updateFromDeviseWidth(constant: countryCellImage.frame.width)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      refreshData()
    }
        
    // MARK: - IBActions
    @IBAction func swapTapped(_ sender: Any) {
        converterView.swapButtons()
        convert(amount: converterView.fromDeviseTF.text)
    }
    
    // MARK: - Convert
    func convert(amount: String?) {
        
        guard let amountText = amount,
            let amount = Double(amountText) else { return }
        
        let fromDeviseName = converterView.fromDeviseButton.name
        let toDeviseName = converterView.toDeviseButton.name
        
        converter?.calculRates(for: amount, fromDevise: fromDeviseName, toDevise: toDeviseName)
        let result = String(converter?.result ?? 0)
       
        guard let toDevise = viewModel?.devises
            .filter({ $0.name == toDeviseName }).first,
        let fromDevise = viewModel?.devises
        .filter({ $0.name == fromDeviseName }).first else { return }
        
        toDevise.value = result
       
        viewModel?.configure(fromDevise: fromDevise,
                             fromDeviseLabel: converterView.fromDeviseLabel,
                             toDevise: toDevise,
                             toDeviseLabel: converterView.toDeviseLabel)
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

        })
    }
}

// MARK: - CollectionView DataSource
extension ExchangeRatesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.identifier, for: indexPath) as! CountryCollectionViewCell

        if countryCellImage == nil {
            countryCellImage = cell.imageContainer
        }
        
        cell.applyShadow()
        
        return cell
    }
}

// MARK: - CollectionView Delegate
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
