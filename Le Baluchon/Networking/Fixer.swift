//
//  Fixer.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

struct Fixer {
    static private let baseURL = "http://data.fixer.io/api/latest"
    static private let accessKey = "?access_key=\(APIKeys.Fixer.rawValue)"
    static private let parameters = "&symbols=USD,GBP,JPY,CNY,CAD"
    
    static var url: String { return Fixer.baseURL + Fixer.accessKey + Fixer.parameters }
}
