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
    
    var fromLangName: String = "Anglais"
    var toLangName: String = "Français"
    
    override func awakeFromNib() {
        applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        applyShadow()
    }
    
    func updateFrom(lang: Lang) {
        fromLangName = lang.name
        translateFromLabel.text = "Traduire un text écrit en " + lang.name.lowercased()
        translateFromImageView.image = UIImage().getImage(for: lang.imageName)
    }
    
    func updateTo(lang: Lang) {
        toLangName = lang.name
        translateToLabel.text = "Traduire un text écrit en " + lang.name.lowercased()
        translateToImageView.image = UIImage().getImage(for: lang.imageName)
    }

    func swapLang() {
        let fromLangNameTemp = fromLangName
        fromLangName = toLangName
        toLangName = fromLangNameTemp
        swapText()
    }
    
    private func swapText() {
        guard fromTextView.text != "Saisis du texte..." && !toTextView.text.isEmpty else { return }
        
        let textFromTextView = fromTextView.text
        fromTextView.text = toTextView.text
        toTextView.text = textFromTextView
    }
}
