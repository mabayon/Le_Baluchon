//
//  WeatherCollectionViewController.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 08/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class WeatherCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupLayout()
    }
    
    func setupCollectionView() {
        // Register cell classes
        self.collectionView!.register(WeatherCollectionViewCell.self,
                                      forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        self.collectionView.isPagingEnabled = true
        
    }

    func setupLayout() {
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        
        layout?.scrollDirection = .horizontal
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier,
                                                      for: indexPath) as! WeatherCollectionViewCell
            
        // Configure the cell
    
        return cell
    }
}

extension WeatherCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let safeAreaWidth = view.safeAreaLayoutGuide.layoutFrame.width
        return CGSize(width: safeAreaWidth, height: safeAreaHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
