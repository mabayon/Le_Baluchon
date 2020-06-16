//
//  NibCreatable.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 12/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

protocol NibCreatable: class {
  
  static var nib: UINib { get }
  static var nibBundle: Bundle? { get }
  static var nibName: String { get }
  
  static func instanceFromNib() -> Self
}
