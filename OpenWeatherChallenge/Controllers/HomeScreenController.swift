//
//  HomeScreenController.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 26/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class HomeScreenController: UIViewController {
    
    //MARK: - Props
    let cellID = "cellId"
    let headerID = "headerId"
    
    public var weather: BehaviorSubject<WeatherModel> = BehaviorSubject(value: WeatherModel())
    public var todayForecast: BehaviorSubject<[List]> = BehaviorSubject(value: [])
    public var forecast: BehaviorSubject<[String:[List]]> = BehaviorSubject(value: [:])
    public var dayList: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    
    private let disposeBag = DisposeBag()
    
    let homeCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
        
    }()
    
    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: - Methods
    private func initialSetup() {
        setupLayout()
        setupCells()
        setupBinds()
        
    }
    
    private func setupLayout() {
        self.view.addSubview(homeCollectionView)
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: homeCollectionView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: homeCollectionView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: homeCollectionView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: homeCollectionView.trailingAnchor),
        ])
        homeCollectionView.backgroundColor = .white
    }
    
    private func setupCells() {
        homeCollectionView.register(HeaderCellView.self, forCellWithReuseIdentifier: headerID)
        homeCollectionView.register(WeatherCellController.self, forCellWithReuseIdentifier: cellID)
        homeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "normalCell")
        
    }
    
    private func setupBinds() {
        
        dayList.bind(to: homeCollectionView.rx.items){[weak self] (collectionView,row,day) -> UICollectionViewCell in
            guard let weakSelf = self else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "normalCell", for: IndexPath.init(row: row, section: 0))
            }
            if day == "header" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weakSelf.headerID, for: IndexPath.init(row: row, section: 0)) as! HeaderCellView
                weakSelf.weather
                    .subscribe({ (weatherModel) in
                        if let weather = weatherModel.element {
                            cell.configureCell(icon: weather.weather?[0].icon, temprature: weather.main?.temp)
                        }
                    })
                    .disposed(by: weakSelf.disposeBag)
                self?.todayForecast
                    .subscribe(onNext: { (results) in
                        var tempratures: [Double] = []
                        var precepition: [Double] = []
                        for items in results {
                            if let temp = items.main?.temp, let precept = items.main?.humidity {
                                tempratures.append(temp)
                                precepition.append(Double(precept))
                            }
                            
                        }
                        cell.tempratureList = tempratures
                        cell.precipitionList = precepition
                        cell.setupChart(entryPoints:tempratures, "ºC")
                        
                    })
                    .disposed(by: weakSelf.disposeBag)
                return cell
                
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weakSelf.cellID, for: IndexPath.init(row: row, section: 0)) as! WeatherCellController
                weakSelf.forecast
                    .subscribe(onNext: { (result) in
                        if let res = result[day]{
                            cell.tempratureList.asObserver().onNext(res)
                            cell.label.text = day
                            cell.backgroundColor = UIColor(hexa: ApplicationColors.lightGrayBackground)
                            
                        }
                    })
                    .disposed(by: weakSelf.disposeBag)
                return cell
                
            }
            
        }.disposed(by: disposeBag)
        
        homeCollectionView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
}

//MARK: - CollectionViewFlowDelegate

extension HomeScreenController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.item == 0) {
            return CGSize(width: UIScreen.main.bounds.width, height: 400)
        }else {
            return CGSize(width: UIScreen.main.bounds.width, height: 200)
            
        }
    }
    
    
}
