//
//  RestaurantItemContentView.swift
//  app
//
//  Created by Mitchell Drew on 14/4/21.
//

import Foundation
import UIKit

class RestaurantItemContentView: UIView, UIContentView {
    let imageview = UIImageView()
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let numReviewsLabel = UILabel()
    let score = UIStackView()
    let favoriteSwitch = UISwitch()
    
    private var currentConfiguration: RestaurantItemContentConfiguration!
        var configuration: UIContentConfiguration {
            get {
                currentConfiguration
            }
            set {
                guard let newConfiguration = newValue as? RestaurantItemContentConfiguration else {
                    return
                }
                apply(configuration: newConfiguration)
            }
        }
    
    init(configuration: RestaurantItemContentConfiguration) {
        super.init(frame: .zero)
        setup()
        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let stack = UIStackView()
        
        stack.backgroundColor = .white
        stack.layer.cornerRadius = 10.0
        stack.layer.shadowColor = UIColor.gray.cgColor
        stack.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        stack.layer.shadowRadius = 6.0
        stack.layer.shadowOpacity = 0.7
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
        
        stack.addArrangedSubview(imageview)
        NSLayoutConstraint.activate([
            imageview.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            imageview.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        let scoreStack = UIStackView()
        scoreStack.axis = .horizontal
        
        
        numReviewsLabel.textColor = .systemGray
        addressLabel.textColor = .systemGray
        numReviewsLabel.font = UIFont.systemFont(ofSize: 14)
        
        let secondaryStack = UIStackView()
        secondaryStack.axis = .horizontal
        secondaryStack.addArrangedSubview(score)
        secondaryStack.addArrangedSubview(numReviewsLabel)
        NSLayoutConstraint.activate([
            score.leadingAnchor.constraint(equalTo: secondaryStack.leadingAnchor),
            numReviewsLabel.leadingAnchor.constraint(equalTo: score.trailingAnchor)
        ])
        
        let spacer = UIView()
        spacer.widthAnchor.constraint(equalToConstant: 5).isActive = true
        stack.addArrangedSubview(spacer)
        
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        stack.addArrangedSubview(textStack)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .systemGray
        
        
        textStack.addArrangedSubview(favoriteSwitch)
        textStack.addArrangedSubview(nameLabel)
        textStack.addArrangedSubview(secondaryStack)
        textStack.addArrangedSubview(addressLabel)
        
        
    }
    
    private func apply(configuration: RestaurantItemContentConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        var priceString = ""
        if let uPrice = configuration.price {
            if(uPrice >= 1){
                for _ in 1 ... uPrice {
                    priceString.append("$")
                }
            }
        }
        if(priceString == ""){
            addressLabel.text = configuration.address
        }
        else{
            addressLabel.text = "\(priceString) - \(configuration.address!)"
        }
        
        if let uIsFav = configuration.isFav { favoriteSwitch.isOn = uIsFav }
        imageview.image = configuration.image
        nameLabel.text = configuration.name
        numReviewsLabel.text = "(\(configuration.numReviews!))"
        score.removeFullyAllArrangedSubviews()
        if let uScore = configuration.score {
            if(uScore >= 1){
                let spacer = UIView()
                for _ in 1 ... Int(uScore) {
                    let imgView = UIImageView(image: UIImage(named: "star"))
                    imgView.translatesAutoresizingMaskIntoConstraints = false
                    imgView.heightAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
                    imgView.widthAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
                    let spacer = UIView()
                    spacer.widthAnchor.constraint(equalToConstant: 5).isActive = true
                    score.addArrangedSubview(imgView)
                    score.addArrangedSubview(spacer)
                }
            }
            else{
                score.removeFromSuperview()
            }
        }
        favoriteSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        if let uName = currentConfiguration.name {
            if let uClosure = currentConfiguration.switchClosure {
                uClosure(uName,value)
            }
        }
    }
}
