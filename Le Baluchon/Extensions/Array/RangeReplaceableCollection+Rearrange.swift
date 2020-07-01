//
//  RangeReplaceableCollection+Rearrange.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 01/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection where Indices: Equatable {
   
    mutating func rearrange(from: Index, to: Index) {
        guard from != to, indices.contains(from), indices.contains(to) else { return }
        insert(remove(at: from), at: to)
    }
}
