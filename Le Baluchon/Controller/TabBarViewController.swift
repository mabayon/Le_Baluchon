//
//  TabBarViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 18/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabBar = self.tabBar as? ShadowTabBar {
            tabBar.setupTabBar()
        }
    }
}
