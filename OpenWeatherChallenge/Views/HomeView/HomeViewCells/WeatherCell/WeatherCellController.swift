//
//  WeatherCellController.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 27/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class WeatherCellController: UICollectionViewCell {
    //MARK: - Props
    let cellID = "cellId"
    let tempratureList: PublishSubject<[List]> = PublishSubject()
    private let disposeBag = DisposeBag()

    let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Title"
        return lbl
    }()
    
    let weatherCellCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupWCCConstrainst()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setupView() {
        addSubview(weatherCellCollectionView)
        addSubview(label)
        setupBinds()
        weatherCellCollectionView.register(WeatherCellView.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    private func setupBinds() {
        tempratureList.bind(to: weatherCellCollectionView.rx.items(cellIdentifier: cellID, cellType: WeatherCellView.self)) { (row, result, cell) in
            cell.configureLbls(
                icon: result.weather?[0].icon,
                hours: result.dt,
                temprature: result.main?.temp)
            
        }
        .disposed(by: disposeBag)
        
        weatherCellCollectionView
            .rx
            .setDelegate(self)
        .disposed(by: disposeBag)
    }
    
    private func setupWCCConstrainst(){
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 40),
            weatherCellCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherCellCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherCellCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 15),
            weatherCellCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
    
}


extension WeatherCellController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.bounds.height)
    }
    
    
    
}
