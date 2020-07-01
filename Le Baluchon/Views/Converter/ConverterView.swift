//
//  ConverterView.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 30/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class ConverterView: UIView {
    
    @IBOutlet weak private var fromDeviseButton: DeviseButton!
    @IBOutlet weak private var toDeviseButton: DeviseButton!
    @IBOutlet weak private var swapButton: UIButton!
    @IBOutlet weak private var fromDeviseLabel: UILabel!
    @IBOutlet weak private var toDeviseLabel: UILabel!
    @IBOutlet weak private var fromDeviseWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var fromDeviseTF: UITextField!

    var fromDeviseName: String? = "EUR" {
        didSet {
            fromDeviseButton.name = fromDeviseName!
            fromDeviseButton.imageView?.image = UIImage().getImage(for: fromDeviseName)
        }
    }
    
    var toDeviseName: String? = "USD" {
        didSet {
            toDeviseButton.name = toDeviseName!
            toDeviseButton.imageView?.image = UIImage().getImage(for: toDeviseName)
        }
    }
    
    var toDeviseResult: String? {
        didSet {
            toDeviseLabel.text = toDeviseResult
        }
    }
    
    var fromDeviseSymbol: String? {
        didSet {
            fromDeviseLabel.text = fromDeviseSymbol
        }
    }
    
    override func awakeFromNib() {
        setupViews()
    }
    
    private func setupViews() {
        swapButton.imageView?.contentMode = .scaleAspectFit
        fromDeviseButton.name = "EUR"
        toDeviseButton.name = "USD"
        fromDeviseButton.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 10.0)
        fromDeviseButton.applyShadow()
        toDeviseButton.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 10.0)
        toDeviseButton.applyShadow()
    }
    
    func swapButtons() {
          let tempButtonName = fromDeviseButton.name
        
          fromDeviseName = toDeviseButton.name
          toDeviseName = tempButtonName
    }
    
    func updateFromDeviseWidth(constant: CGFloat) {
        fromDeviseWidthConstraint.constant = constant
    }
}
