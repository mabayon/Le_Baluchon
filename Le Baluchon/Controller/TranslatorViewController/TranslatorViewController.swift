//
//  TranslatorViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 17/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var translatorView: TranslatorView!
    @IBOutlet weak var mentionLabel: UILabel!
    
    // MARK: Instance Properties
    
    var networkClient = NetworkClients.googleTranslate
    
    var dataTask: URLSessionDataTask?
    
    var translationFromLang = "" {
        didSet {
            // Get the lang from TranslatedLang
            guard let lang = TranslatedLang.languages.first(where: { $0.name == translationFromLang }) else { return }
            // Update the view
            translatorView.updateFrom(lang: lang)
            // Update the source of GoogleTranslate
            GoogleTranslate.sourceLang = lang.code
        }
    }
    
    var translationToLang = "" {
        didSet {
            guard let lang = TranslatedLang.languages.first(where: { $0.name == translationToLang }) else { return }
            translatorView.updateTo(lang: lang)
            GoogleTranslate.targetLang = lang.code
        }
    }
    
    var isTranslatedFromFrench = false
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translatorView.fromTextView.delegate = self
        createPlaceholder(for: translatorView.fromTextView)
        translationFromLang = "Anglais"
        translationToLang = "Français"
    }
    
    // MARK: IBAction
    
    // Swap the lang when the user tapped the button
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
    
    // MARK: Networking
    
    func refreshData() {
        guard dataTask == nil else { return }
        
        dataTask = networkClient.getData(completion: { (translation, error) in
            self.dataTask = nil
            
            guard let translation = translation as? Translation else {
                let alertController = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true)
                }))
                self.present(alertController, animated: true)
                return
            }
            // Get the translated Text
            self.translatorView.toTextView.text = translation.data.map({ $0 }).first.map({ $0 })?.value.first?.translatedText
        })
    }
}

// MARK: CollectionView - DataSource
extension TranslatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number of section minus French
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

// MARK: CollectionView - FlowLayout
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

// MARK: CollectionView - Delegate
extension TranslatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CountryCollectionViewCell
        changeLang(with: cell)
    }
    
    func changeLang(with cell: CountryCollectionViewCell) {
        
        if isTranslatedFromFrench {
            guard cell.imageView.image != translatorView.translateToImageView.image else { return }
            // Change the label above the second textView
            translatorView.toLangName = cell.label.text ?? ""
            // Update the view and the target
            translationToLang = translatorView.toLangName
            // Do a request
            networkClient.reloadGoogleTranslate()
            networkClient = NetworkClients.googleTranslate
            refreshData()
        } else {
            guard cell.imageView.image != translatorView.translateFromImageView.image else { return }
            // Change the label above the first textView
            translatorView.fromLangName = cell.label.text ?? ""
            // Update the view and the source
            translationFromLang = translatorView.fromLangName
            createPlaceholder(for: translatorView.fromTextView)
            // Erase the toTextView
            translatorView.toTextView.text = ""
        }
    }
}

// MARK: TextView - Delegate
extension TranslatorViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard translatorView.fromTextView.text != "Saisis du texte…",
              let textToTranslate = translatorView.fromTextView.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        // Update the text to translate
        GoogleTranslate.textToTranslate = textToTranslate
        // And make a request
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
