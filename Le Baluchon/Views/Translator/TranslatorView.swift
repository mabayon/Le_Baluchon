//
//  TranslatorView.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 21/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class TranslatorView: UIView {

    @IBOutlet weak var fromTextView: UITextView!
    @IBOutlet weak var toTextView: UITextView!
    @IBOutlet weak var translateFromLabel: UILabel!
    @IBOutlet weak var translateToLabel: UILabel!
    @IBOutlet weak var translateFromImageView: UIImageView!
    @IBOutlet weak var translateToImageView: UIImageView!

    @IBOutlet weak var fromView: UIView! {
        didSet {
            fromView.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
            fromView.applyShadow()
        }
    }
        
    @IBOutlet weak var toView: UIView! {
        didSet {
            toView.applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])
            toView.applyShadow()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        applyShadow()
    }
}
