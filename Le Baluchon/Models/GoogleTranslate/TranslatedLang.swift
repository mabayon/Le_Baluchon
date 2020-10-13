//
//  TranslatedLang.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 21/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct TranslatedLang {
    static let languages = [Lang(name: "Anglais", imageName: "English", code: "en"),
                            Lang(name: "Espagnol", imageName: "Spanish", code: "es"),
                            Lang(name: "Italien", imageName: "Italian", code: "it"),
                            Lang(name: "Chinois", imageName: "Chinese", code: "zh"),
                            Lang(name: "Français", imageName: "French", code: "fr")
    ]
}

struct Lang {
    let name: String
    let imageName: String
    let code: String
}
