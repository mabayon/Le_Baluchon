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
    
    var fromLangName: String = "Anglais" {
        didSet {
            let lang = TranslatedLang.languages.first(where: { $0.name == fromLangName })
            translateFromLabel.text = "Traduire un text écrit en " + fromLangName.lowercased()
            translateFromImageView.image = UIImage().getImage(for: lang?.imageName)
        }
    }
    
    var toLangName: String = "Français" {
        didSet {
            let lang = TranslatedLang.languages.first(where: { $0.name == toLangName })
            translateToLabel.text = "Traduire en " + toLangName.lowercased()
            translateToImageView.image = UIImage().getImage(for: lang?.imageName)
        }
    }
    
    override func awakeFromNib() {
        applyRounded(at: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        applyShadow()
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
