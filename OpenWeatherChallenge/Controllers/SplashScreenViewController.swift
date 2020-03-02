//
//  SplashScreenViewController.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 25/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SplashScreenViewController: UIViewController {
    
    // MARK: Props
    let bagView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "previsao" )
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lbl.text = ConstantsStrings.OpenWeaderSplash
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let homeVC = HomeScreenController()
    
    public var loading = PublishSubject<Bool>()
    let homeViewModel = HomeViewModel()
    //Dispose bag
    private let disposeBag = DisposeBag()
    
    
    // MARK: Lyfecicle
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexa: ApplicationColors.splash_screen_background)
        addSplashImage()
        setupBinds()
        homeViewModel.requestData()
    }
    
    // MARK: Methods
    
    private func setupBinds() {
        
        homeViewModel
            .loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (isLoading) in
                self?.navigateToHome()
                
            })
            .disposed(by: disposeBag)
        
        homeViewModel
            .weather
            .observeOn(MainScheduler.instance)
            .bind(to: homeVC.weather)
            .disposed(by: disposeBag)
        
        homeViewModel
            .forecast
            .observeOn(MainScheduler.instance)
            .bind(to: homeVC.forecast)
            .disposed(by: disposeBag)
        
        homeViewModel
            .listOfSchedule
            .observeOn(MainScheduler.instance)
            .bind(to: homeVC.dayList)
            .disposed(by: disposeBag)
        
        homeViewModel
            .todayForecast
            .observeOn(MainScheduler.instance)
            .bind(to: homeVC.todayForecast)
            .disposed(by: disposeBag)
    }
    
    private func navigateToHome() {
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    private func addSplashImage() {
        view.addSubview(bagView)
        view.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            bagView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bagView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bagView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            //loading Label
            loadingLabel.topAnchor.constraint(equalTo: bagView.bottomAnchor, constant: 10),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
    }
    
    
}
