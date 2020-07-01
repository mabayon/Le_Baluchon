//
//  ConverterView.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 30/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class ConverterView: UIView {
    
    @IBOutlet weak private var fromCurrencyButton: CurrencyButton!
    @IBOutlet weak private var toCurrencyButton: CurrencyButton!
    @IBOutlet weak private var swapButton: UIButton!
    @IBOutlet weak private var fromCurrencyLabel: UILabel!
    @IBOutlet weak private var toCurrencyLabel: UILabel!
    @IBOutlet weak private var fromCurrencyWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var fromCurrencyTF: UITextField!

    var fromCurrencyName: String = "EUR" {
        didSet {
            fromCurrencyButton.name = fromCurrencyName
            fromCurrencyButton.imageView?.image = UIImage().getImage(for: fromCurrencyName)
        }
    }
    
    var toCurrencyName: String = "USD" {
        didSet {
            toCurrencyButton.name = toCurrencyName
            toCurrencyButton.imageView?.image = UIImage().getImage(for: toCurrencyName)
        }
    }
    
    var toCurrencyResult: String? {
        didSet {
            toCurrencyLabel.text = toCurrencyResult
        }
    }
    
    var fromCurrencySymbol: String? {
        didSet {
            fromCurrencyLabel.text = fromCurrencySymbol
        }
    }
    
    override func awakeFromNib() {
        setupViews()
    }
    
    private func setupViews() {
        swapButton.imageView?.contentMode = .scaleAspectFit
        fromCurrencyButton.name = "EUR"
        toCurrencyButton.name = "USD"
        fromCurrencyButton.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 10.0)
        fromCurrencyButton.applyShadow()
        toCurrencyButton.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 10.0)
        toCurrencyButton.applyShadow()
    }
    
    func swapButtons() {
          let tempButtonName = fromCurrencyButton.name
        
          fromCurrencyName = toCurrencyButton.name
          toCurrencyName = tempButtonName
    }
    
    func updateFromCurrencyWidth(constant: CGFloat) {
        fromCurrencyWidthConstraint.constant = constant
    }
}
