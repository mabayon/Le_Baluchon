//
//  UIView+ApplyShadow.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 18/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

extension UIView {
    func applyShadow(shadowOffset: CGSize = .zero,
                     shadowRadius: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = 0.6
        layer.shadowRadius = shadowRadius
        layer.shadowColor = UIColor.gray.cgColor
    }
}
