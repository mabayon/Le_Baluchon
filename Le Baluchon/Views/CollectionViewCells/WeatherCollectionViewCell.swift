//
//  WeatherCollectionViewCell.swift
//  Le Baluchon
//
//  Created by Mahieu Bayon on 08/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    let currentWeatherView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 250/255, green: 165/255, blue: 98/255, alpha: 1)
        return view
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Paris"
        label.font = UIFont(name: "Inter-Bold", size: 30)
        label.textColor = .white
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "21°"
        label.font = UIFont(name: "Inter-Bold", size: 60)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weather_clear_sky_d")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let currentForecastStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ensoleillé"
        label.font = UIFont(name: "Inter-Regular", size: 15)
        label.textColor = .white
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Mercredi"
        label.font = UIFont(name: "Inter-Bold", size: 25)
        label.textColor = .white
        return label
    }()
    
    let forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        addSubview(currentWeatherView)
        
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        currentWeatherView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        currentWeatherView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        currentWeatherView.addSubview(cityLabel)
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        currentWeatherView.addSubview(currentForecastStackView)
        currentForecastStackView.addArrangedSubview(tempLabel)
        currentForecastStackView.addArrangedSubview(weatherImageView)
        
        currentForecastStackView.translatesAutoresizingMaskIntoConstraints = false
        currentForecastStackView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20).isActive = true
        currentForecastStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        currentForecastStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.heightAnchor.constraint(equalTo: tempLabel.heightAnchor).isActive = true
        
        addSubview(weatherDescriptionLabel)
        
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDescriptionLabel.topAnchor.constraint(equalTo: currentForecastStackView.bottomAnchor, constant: 20).isActive = true
        weatherDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(dayLabel)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 20).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: -10).isActive = true
        
        addSubview(forecastTableView)
        
        forecastTableView.translatesAutoresizingMaskIntoConstraints = false
        forecastTableView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor).isActive = true
        forecastTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        forecastTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        forecastTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension WeatherCollectionViewCell {
    func setTableViewDataSourceDelegate(dataSourceDelegate: UITableViewDataSource & UITableViewDelegate, forRow row: Int) {
        forecastTableView.delegate = dataSourceDelegate
        forecastTableView.dataSource = dataSourceDelegate
        forecastTableView.tag = row
        forecastTableView.reloadData()
    }
}
