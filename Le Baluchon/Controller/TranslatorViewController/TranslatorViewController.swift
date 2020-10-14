//
//  TranslatorViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 17/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController {
    
    @IBOutlet weak var translatorView: TranslatorView!
    @IBOutlet weak var mentionLabel: UILabel!
    
    var networkClient = NetworkClients.googleTranslate
    
    var dataTask: URLSessionDataTask?
    
    var translationFromLang = "" {
        didSet {
            guard let lang = TranslatedLang.languages.first(where: { $0.name == translationFromLang }) else { return }
            translatorView.fromLangName = lang.name
            translatorView.translateFromImageView.image = UIImage().getImage(for: lang.imageName)
            GoogleTranslate.sourceLang = lang.code
        }
    }
    
    var translationToLang = "" {
        didSet {
            guard let lang = TranslatedLang.languages.first(where: { $0.name == translationToLang }) else { return }
            translatorView.toLangName = lang.name
            translatorView.translateToImageView.image = UIImage().getImage(for: lang.imageName)
            GoogleTranslate.targetLang = lang.code
        }
    }
    
    var isTranslatedFromFrench = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translatorView.fromTextView.delegate = self
        createPlaceholder(for: translatorView.fromTextView)
        translationFromLang = "Anglais"
        translationToLang = "Français"
    }
    
    func refreshData() {
        guard dataTask == nil else { return }
        
        dataTask = networkClient.getData(completion: { (translation, error) in
            self.dataTask = nil

            guard let translation = translation as? Translation else { return }
            
            self.translatorView.toTextView.text = translation.data.map({ $0 }).first.map({ $0 })?.value.first?.translatedText
        })
    }
    
    @IBAction func swapTapped(_ sender: Any) {
        translatorView.swapLang()
        translationFromLang = translatorView.fromLangName
        translationToLang = translatorView.toLangName
        if isTranslatedFromFrench {
            isTranslatedFromFrench = false
            mentionLabel.text = "Choisis ta langue à traduire en français"
        } else {
            isTranslatedFromFrench = true
            mentionLabel.text = "Choisis ta langue à traduire du français"
        }
    }
}

extension TranslatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TranslatedLang.languages.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.identifier, for: indexPath) as! CountryCollectionViewCell
        
        let imageName = TranslatedLang.languages[indexPath.row].imageName
        cell.imageView.image = UIImage().getImage(for: imageName)
        cell.label.text = TranslatedLang.languages[indexPath.row].name
        return cell
    }
}

extension TranslatorViewController: UICollectionViewDelegateFlowLayout {
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

extension TranslatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CountryCollectionViewCell
        
        changeLang(with: cell)
    }
    
    func changeLang(with cell: CountryCollectionViewCell) {
        
        if isTranslatedFromFrench {
            guard cell.imageView.image != translatorView.translateToImageView.image else { return }
            translatorView.toLangName = cell.label.text ?? ""
            translationToLang = translatorView.toLangName
        } else {
            guard cell.imageView.image != translatorView.translateFromImageView.image else { return }
            translatorView.fromLangName = cell.label.text ?? ""
            translationFromLang = translatorView.fromLangName
        }
        
        translatorView.toTextView.text = ""
        createPlaceholder(for: translatorView.fromTextView)
    }
}

extension TranslatorViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard translatorView.fromTextView.text != "Saisis du texte…",
            let textToTranslate = translatorView.fromTextView.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return
        }
        
        GoogleTranslate.textToTranslate = textToTranslate
        networkClient.reloadGoogleTranslate()
        networkClient = NetworkClients.googleTranslate
        refreshData()
    }
    
    func createPlaceholder(for textView: UITextView) {
        textView.text = "Saisis du texte…"
        textView.textColor = UIColor.lightGray
        
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                        to: textView.beginningOfDocument)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Dismiss keyboard when return tapped
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            createPlaceholder(for: textView)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = ""
        }
        return true
    }
    
    // Prevent the user from changing the position of the cursor while the placeholder's visible.
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
