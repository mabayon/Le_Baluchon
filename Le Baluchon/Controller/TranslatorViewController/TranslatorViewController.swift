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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translatorView.fromTextView.delegate = self
        createPlaceholder(for: translatorView.fromTextView)
    }
    
    func createPlaceholder(for textView: UITextView) {
        textView.text = "Saisis du texte…"
        textView.textColor = UIColor.lightGray

        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                        to: textView.beginningOfDocument)
    }
}

extension TranslatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TranslatedLang.languages.count
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

extension TranslatorViewController: UITextViewDelegate {
    
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
