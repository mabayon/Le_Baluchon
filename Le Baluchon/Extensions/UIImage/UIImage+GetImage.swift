//
//  UIImage+GetImage.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 01/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

extension UIImage {
    func getImage(for country: String?) -> UIImage? {
        guard let name = country else { return UIImage() }
            
        return UIImage(named: name)
    }
}
