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
    static private let accessKey = "?key=\(APIKeys.GoogleTranslate.rawValue)"
    static private var text = "&q="
    static private var source = "&fr"
    static private var target = "&en"
    static private let format = "&format=text"
    
    static private var parameters: String { return GoogleTranslate.source + GoogleTranslate.target + GoogleTranslate.text + GoogleTranslate.format }

    
    static var textToTranslate = "" {
        didSet {
            text = "&q=" + textToTranslate
        }
    }
    
    static var sourceLang = "" {
        didSet {
            source = "&source=" + sourceLang
        }
    }
    
    static var targetLang = "" {
        didSet {
            target = "&target=" + targetLang
        }
    }

    
    static var url: String { return GoogleTranslate.baseURL + GoogleTranslate.accessKey + GoogleTranslate.parameters }
}
