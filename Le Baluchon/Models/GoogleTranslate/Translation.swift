//
//  Translate.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 16/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct Translation: Decodable, Equatable {
    let data: [String: [TranslatedText]]
}

struct TranslatedText: Decodable, Equatable {
    let translatedText: String
}
