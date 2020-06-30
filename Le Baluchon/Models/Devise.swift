//
//  Devise.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 10/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation
import UIKit

class Devise: Equatable {
    
    static func == (lhs: Devise, rhs: Devise) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    var value: String
    let symbol: String
    let image: UIImage
    
    init(name: String, value: String, symbol: String, image: UIImage) {
        self.name = name
        self.value = value
        self.symbol = symbol
        self.image = image
    }
}
