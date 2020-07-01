//
//  Devise.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 10/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

class Devise: Equatable {
    
    static func == (lhs: Devise, rhs: Devise) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    var value: String
    let symbol: String
    
    init(name: String, value: String, symbol: String) {
        self.name = name
        self.value = value
        self.symbol = symbol
    }
}
