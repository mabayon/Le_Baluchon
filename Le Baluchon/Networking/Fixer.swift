//
//  Fixer.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct Fixer {
    static let baseURL = "http://data.fixer.io/api"
    static let accessKey = "?access_key=\(APIKeys.Fixer.rawValue)"
    static let parameters = "&symbols=USD,GBP,JPY,CNY,CAD"
    
    static var url: String { return Fixer.baseURL + Fixer.accessKey + Fixer.parameters }
}
