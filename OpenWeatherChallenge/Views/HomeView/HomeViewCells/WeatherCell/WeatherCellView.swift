//
//  WeatherCellView.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 01/03/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class WeatherCellView: UICollectionViewCell {
    
    //MARK: - Props
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let tempLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "10º"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let hrLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "01"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .lightGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.backgroundColor = .brown
        stack.translatesAutoresizingMaskIntoConstraints = false
       return stack
    }()
    
    //MARK: - Lifecicle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupCell()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func configureLbls(icon: String?, hours: Int?, temprature: Double?){
        
        if let icon = icon, let url = NetworkFunctions.getIconUrl(icon: icon) {
            self.icon.kf.setImage(with: url, options: [.transition(.fade(0.5))])
        }
        
        if let temp = temprature {
            tempLabel.text = "\(Int(temp.rounded()))º"
        }
        
        hrLabel.text = Date().getFormatHours(input: Date().getCurrentStamp(stamp: hours)) + " "
        
    }
    
    func setupIcon(icon: String?) {
        if let icon = icon, let url = NetworkFunctions.getIconUrl(icon: icon) {
            self.icon.kf.setImage(with: url, options: [.transition(.fade(0.5))])
        }
    }
    
    private func setupCell() {
        addSubview(stackView)
        stackView.addArrangedSubview(icon)
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(hrLabel)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
