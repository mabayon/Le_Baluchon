//
//  UIView+ApplyTopRoundedCorners.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 18/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

extension UIView {
    func applyRounded(at corners: CACornerMask, cornerRadius: CGFloat = 25.0) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
    }
}
