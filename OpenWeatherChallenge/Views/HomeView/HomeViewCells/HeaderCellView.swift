//
//  HeaderCellView.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 27/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class HeaderCellView: UICollectionViewCell{
    //MARK: - PROPS
    var tempratureList: [Double] = []
    var precipitionList: [Double] = []
    var current: PublishSubject <String> = PublishSubject()
    
    private let disposeBag = DisposeBag()

    let labelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let precipitationLabel: UIButton = {
        let btn = UIButton()
        btn.setTitle(ConstantsStrings.Precipitation, for: .normal)
        btn.setTitleColor(.darkText, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let tempratureLabel: UIButton = {
        let btn = UIButton()
        btn.setTitle(ConstantsStrings.Temprature, for: .normal)
        btn.setTitleColor(.darkText, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let checkBoxOne: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexa: ApplicationColors.darkGrayBackground)
        return view
    }()
    
    let checkBoxTwo: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor =  UIColor(hexa: ApplicationColors.selectBlue)
        return view
    }()
    
    let clouds: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(imageLiteralResourceName: "clouds")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let graph: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 6
        return view
    }()
    
    let chart: LineCharView = {
        let view = LineCharView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let icon: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let tempLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "10º"
        lbl.textColor = .lightText
        lbl.font = UIFont.systemFont(ofSize: 70)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let tempTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "It is now"
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        lbl.textColor = .lightText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindings()
        setupViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func configureCell(icon: String?, temprature: Double?){
        
        if let icon = icon, let url = NetworkFunctions.getIconUrl(icon: icon) {
            self.icon.kf.setImage(with: url, options: [.transition(.fade(0.5))])
        }
        
        if let temp = temprature {
            tempLabel.text = "\(Int(temp.rounded()))º"
        }
        
        tempTitle.text = ConstantsStrings.homeTitle
        
        backgroundColor = UIColor(hexa: ApplicationColors.lightGrayBackground)
        
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        current.onNext(sender.titleLabel?.text ?? "noValue")
    }
    
    private func bindings() {
        tempratureLabel.addTarget(self, action:#selector(buttonClicked(_:)), for: .touchUpInside)
        precipitationLabel.addTarget(self, action:#selector(buttonClicked(_:)), for: .touchUpInside)
        
        current
            .subscribeOn(MainScheduler.instance)
            .bind {[weak self] (value) in
                
                
                if let precipitionList = self?.precipitionList, value == ConstantsStrings.Precipitation {
                    self?.checkBoxOne.backgroundColor = UIColor(hexa: ApplicationColors.selectBlue)
                    self?.checkBoxTwo.backgroundColor = UIColor(hexa: ApplicationColors.darkGrayBackground)
                    self?.setupChart(entryPoints: precipitionList, "%")
                    
                }else if let tempratureList = self?.tempratureList, value == ConstantsStrings.Temprature{
                    self?.checkBoxTwo.backgroundColor = UIColor(hexa: ApplicationColors.selectBlue)
                    self?.checkBoxOne.backgroundColor = UIColor(hexa: ApplicationColors.darkGrayBackground)
                    self?.setupChart(entryPoints: tempratureList, "ºC")
                    
                }
        }.disposed(by: disposeBag)
    }
    
    private func setupViewCell() {
        addSubview(clouds)
        addSubview(graph)
        graph.addSubview(chart)
        graph.addSubview(labelContainer)
        labelContainer.addSubview(tempratureLabel)
        labelContainer.addSubview(precipitationLabel)
        labelContainer.addSubview(checkBoxOne)
        labelContainer.addSubview(checkBoxTwo)
        
        
        addSubview(icon)
        addSubview(tempLabel)
        addSubview(tempTitle)
        
        setupConstrains()
    }
    
    func setupChart(entryPoints: [Double], _ metric: String) {
        chart.metric = metric
        chart.dataEntries = entryPoints
        chart.isCurved = true
    }
    
    private func setupConstrains(){
        NSLayoutConstraint.activate([
            
            // Setup clouds
            clouds.topAnchor.constraint(equalTo: topAnchor, constant: -40),
            clouds.leadingAnchor.constraint(equalTo: leadingAnchor),
            clouds.trailingAnchor.constraint(equalTo: trailingAnchor),
            clouds.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            //Setup Icon
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            //Setup temprature label
            tempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            tempLabel.heightAnchor.constraint(equalToConstant: 60),
            
            //Setup title
            tempTitle.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            tempTitle.trailingAnchor.constraint(equalTo: tempLabel.leadingAnchor, constant: -20),
            tempTitle.heightAnchor.constraint(equalToConstant: 40),
            
            //Setup Graph
            graph.topAnchor.constraint(equalTo: clouds.bottomAnchor, constant: -10),
            graph.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            graph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            graph.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            //Setup chart
            chart.topAnchor.constraint(equalTo: graph.topAnchor),
            chart.leadingAnchor.constraint(equalTo: graph.leadingAnchor),
            chart.trailingAnchor.constraint(equalTo: graph.trailingAnchor, constant: -30),
            chart.bottomAnchor.constraint(equalTo: graph.bottomAnchor),
            
            //setup Container
            labelContainer.topAnchor.constraint(equalTo: graph.topAnchor, constant: 10),
            labelContainer.leadingAnchor.constraint(equalTo: graph.leadingAnchor),
            labelContainer.widthAnchor.constraint(equalToConstant: 100),
            labelContainer.heightAnchor.constraint(equalToConstant: 50),
            
            //setup precepition label
            precipitationLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor),
            precipitationLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: 15),
            precipitationLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            precipitationLabel.heightAnchor.constraint(equalToConstant: 25),
            
            //check box one
            checkBoxOne.centerYAnchor.constraint(equalTo: precipitationLabel.centerYAnchor),
            checkBoxOne.trailingAnchor.constraint(equalTo: precipitationLabel.leadingAnchor, constant: -5),
            checkBoxOne.widthAnchor.constraint(equalToConstant: 8),
            checkBoxOne.heightAnchor.constraint(equalToConstant: 8),
            
            
            //            //setup temprature label
            tempratureLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor),
            tempratureLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: 15),
            tempratureLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            tempratureLabel.heightAnchor.constraint(equalToConstant: 25),
            
            //check box two
            checkBoxTwo.centerYAnchor.constraint(equalTo: tempratureLabel.centerYAnchor),
            checkBoxTwo.trailingAnchor.constraint(equalTo: tempratureLabel.leadingAnchor, constant: -5),
            checkBoxTwo.widthAnchor.constraint(equalToConstant: 8),
            checkBoxTwo.heightAnchor.constraint(equalToConstant: 8),
            
        ])
        
    }
    
}
