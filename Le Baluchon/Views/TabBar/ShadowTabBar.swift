//
//  ShadowTabBar.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 18/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class ShadowTabBar: UITabBar {

    func setupTabBar() {
        if #available(iOS 13, *) {
            // iOS 13:
            let appearance = self.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            self.standardAppearance = appearance
        } else {
            // iOS 12 and below:
            self.shadowImage = UIImage()
            self.backgroundImage = UIImage()
        }

        self.applyShadow()
    }
}
