//
//  GoogleTranslate.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 16/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct GoogleTranslate {
    static private let baseURL = "https://translation.googleapis.com/language/translate/v2"
    static private let accessKey = "?key=\(APIKeys.GoogleTranslate)"
    static private let parameters = GoogleTranslate.source + GoogleTranslate.target + GoogleTranslate.text + GoogleTranslate.format
    static private var text = "&q="
    static private var source = "&fr"
    static private var target = "&en"
    static private let format = "&format=text"
    
    var text: String {
        didSet {
            GoogleTranslate.text = "&q=" + text
        }
    }
    
    var source: String {
        didSet {
            GoogleTranslate.source = "&" + source
        }
    }
    
    var target: String {
        didSet {
            GoogleTranslate.target = "&" + target
        }
    }

    
    static var url: String { return GoogleTranslate.baseURL + GoogleTranslate.accessKey + GoogleTranslate.parameters }
}
