//
//  ConverterView.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 30/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class ConverterView: UIView {
    
    @IBOutlet weak var fromDeviseButton: DeviseButton! {
        didSet {
            
        }
    }
    @IBOutlet weak var toDeviseButton: DeviseButton! {
           didSet {
           }
       }
    
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var fromDeviseTF: UITextField!
    @IBOutlet weak var fromDeviseLabel: UILabel!
    @IBOutlet weak var toDeviseLabel: UILabel!
    
    @IBOutlet weak var fromDeviseWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        setupViews()
    }
    
    func setupViews() {
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
          let tempButtonImage = fromDeviseButton.imageView?.image
        
          fromDeviseButton.name = toDeviseButton.name
          fromDeviseButton.imageView?.image = toDeviseButton.imageView?.image
          toDeviseButton.name = tempButtonName
          toDeviseButton.imageView?.image = tempButtonImage
    }
    
    func updateFromDeviseWidth(constant: CGFloat) {
        fromDeviseWidthConstraint.constant = constant
    }
}
