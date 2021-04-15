//
//  RestaurantItemContentConfiguration.swift
//  app
//
//  Created by Mitchell Drew on 14/4/21.
//

import Foundation
import UIKit

struct RestaurantItemContentConfiguration: UIContentConfiguration, Hashable {
    var name:String?
    var address:String?
    
    func makeContentView() -> UIView & UIContentView {
        return RestaurantItemContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> RestaurantItemContentConfiguration {
        guard state is UICellConfigurationState else {
                return self
            }
            
            var updatedConfiguration = self
        
            return updatedConfiguration
    }
}
