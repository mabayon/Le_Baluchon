//
//  TodayWeatherView.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 03/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class TodayWeatherView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!


    override func awakeFromNib() {
        let image = imageView.image
        imageView.image = image?.aspectFitImage(inRect: imageView.frame)
        imageView.contentMode = .right
    }
}
