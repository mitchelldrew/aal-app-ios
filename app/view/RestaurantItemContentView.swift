//
//  RestaurantItemContentView.swift
//  app
//
//  Created by Mitchell Drew on 14/4/21.
//

import Foundation
import UIKit

class RestaurantItemContentView: UIView, UIContentView {
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    
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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
        
        // Add image view to stack view
        addressLabel.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(addressLabel)
        
        // Add label to stack view
        nameLabel.textAlignment = .center
        stackView.addArrangedSubview(nameLabel)
    }
    
    private func apply(configuration: RestaurantItemContentConfiguration) {
    
        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else {
            return
        }
        
        // Replace current configuration with new configuration
        currentConfiguration = configuration
        
        // Set data to UI elements
        nameLabel.text = configuration.name
        addressLabel.text = configuration.address
    }
}
