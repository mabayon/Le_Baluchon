//
//  ForecastTableViewCell.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 07/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Jeudi"
        label.font = UIFont(name: "Inter-Regular", size: 15)
        label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        return label
    }()
    
    var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weather_clear_sky_d")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(dayLabel)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(weatherImage)
        
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 5).isActive = true
        weatherImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        weatherImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        weatherImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        weatherImage.heightAnchor.constraint(equalTo: weatherImage.widthAnchor).isActive = true
    }
}
