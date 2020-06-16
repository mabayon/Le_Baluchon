//
//  StoryboardCreatable.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 12/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

protocol StoryboardCreatable: class {
  static var storyboard: UIStoryboard { get }
  static var storyboardBundle: Bundle? { get }
  static var storyboardIdentifier: String { get }
  static var storyboardName: String { get }
  
  static func instanceFromStoryboard() -> Self
}
