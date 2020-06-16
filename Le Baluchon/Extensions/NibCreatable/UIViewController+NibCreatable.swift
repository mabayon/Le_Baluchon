//
//  UIViewController+NibCreatable.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 12/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

extension UIViewController: NibCreatable {
  
  @objc final class var nib: UINib {
    let nibName = Self.nibName
    let nibBundle = Self.nibBundle
    return UINib(nibName: nibName, bundle: nibBundle)
  }
  
  @objc class var nibBundle: Bundle? {
    return Bundle(for: self)
  }
  
  @objc class var nibName: String {
    return "\(self)"
  }
  
  @objc final class func instanceFromNib() -> Self {
    return Self.init(nibName: nibName, bundle: nibBundle)
  }
}
