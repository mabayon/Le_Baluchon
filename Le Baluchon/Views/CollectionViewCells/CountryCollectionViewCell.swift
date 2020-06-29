//
//  CountryCollectionViewCell.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 18/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    
    let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.applyRounded(at:
            [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 10.0)
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "USD")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Inter-Regular", size: 15)
        label.contentMode = .center
        label.text = "USD"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(label)
        addSubview(imageContainer)
        imageContainer.addSubview(imageView)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor).isActive = true
        imageContainer.bottomAnchor.constraint(equalTo: label.topAnchor).isActive = true
        imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 0.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 0.5).isActive = true

        
    }
}
