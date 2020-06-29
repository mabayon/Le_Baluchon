//
//  ExchangeRateViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 05/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class ExchangeRatesViewController: UIViewController {
    
    @IBOutlet weak var ratesView: UIView! {
        didSet {
            ratesView.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            ratesView.applyShadow()
        }
    }
    @IBOutlet weak var fromDeviseButton: UIButton! {
        didSet {
            fromDeviseButton.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 10.0)
            fromDeviseButton.applyShadow()
        }
    }
    @IBOutlet weak var toDeviseButton: UIButton! {
           didSet {
            toDeviseButton.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 10.0)
            toDeviseButton.applyShadow()
           }
       }
    
    @IBOutlet weak var swapButton: UIButton!
    
    @IBOutlet weak var fromDeviseWidthConstraint: NSLayoutConstraint!
    
    var imageCountryCell: UIView?

    // MARK: - Instance Properties
    var networkClient: ExchangeRatesService = ExchangeRatesClient.shared
    
    var viewModels: ExchangeRatesViewModel?
    var dataTask: URLSessionDataTask?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        swapButton.imageView?.contentMode = .scaleAspectFit
    }

    override func viewDidAppear(_ animated: Bool) {
        if let imageCountryCell = imageCountryCell {
            fromDeviseWidthConstraint.constant = imageCountryCell.frame.width
        }
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

extension ExchangeRatesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.identifier, for: indexPath) as! CountryCollectionViewCell

        if imageCountryCell == nil {
            imageCountryCell = cell.imageContainer
        }
        
        cell.applyShadow()
        
        return cell
    }
}

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
